import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:auth_service/auth_service.dart';
import 'package:auth_service/appauth/model/auth_id_token_model.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

// coverage:ignore-file
//TODO: need to have code coverage for this file

class AppAuthService implements AuthService {
  // Keys for configuration parameters
  static const auth0DiscoveryUrl = 'auth0DiscoveryUrl';
  static const auth0Authority = 'auth0Authority';
  static const auth0Domain = 'auth0Domain';
  static const auth0ClientId = 'auth0ClientId';
  static const auth0BundleId = 'auth0BundleId';
  static const auth0Scopes = 'auth0Scopes';
  static const auth0ClientSecret = 'auth0ClientSecret';
  static const auth0UnencodedPath = 'auth0UnencodedPath';

  // Keys for http response
  static const respAccessToken = "access_token";
  static const respRefreshToken = "refresh_token";
  static const respExpiresIn = "expires_in";
  static const respIdToken = "id_token";

  static const idTokenLogoutParameter = '?id_token_hint=';

  late http.Client _httpClient;

  bool _initialised = false;

  final FlutterAppAuth appAuth = FlutterAppAuth();

  String? _accessToken;
  String? _refreshToken;
  String? _accessTokenExpirationDate;
  String? _idToken;

  User? user;
  Auth0IdToken? _auth0IdToken;

  bool _requireLogin = true;

  late String _auth0DiscoveryUrl;
  late String _auth0Authority;
  late String _auth0Domain;
  late String _auth0ClientId;
  late String _auth0BundleId;
  late List<String> _auth0Scopes;
  late String _auth0ClientSecret;
  late String _auth0UnencodedPath;

  late String _auth0Issuer;
  late String _auth0RedirectUri;

  String? _endSessionEndpoint;
  String? _userInfoEndpoint;

  @override
  User? getActiveUser() {
    return user;
  }

  @override
  Future<bool> initialise(
      Map<String, dynamic> parameters, http.Client httpClient) async {
    _auth0DiscoveryUrl = parameters[auth0DiscoveryUrl];
    _auth0Authority = parameters[auth0Authority];
    _auth0Domain = parameters[auth0Domain];
    _auth0ClientId = parameters[auth0ClientId];
    _auth0BundleId = parameters[auth0BundleId];
    _auth0Scopes = parameters[auth0Scopes];
    _auth0Issuer = 'https://$_auth0Domain';
    _auth0RedirectUri = '$_auth0BundleId://login-callback';
    _auth0ClientSecret = parameters[auth0ClientSecret];
    _auth0UnencodedPath = parameters[auth0UnencodedPath];

    _httpClient = httpClient;

    await _doDiscovery();

    return _initialised;
  }

  Future<void> _doDiscovery() async {
    late http.Response response;
    // Query the Discovery URL to obtain certain endpoints
    var _discUrl = _auth0Issuer + '/' + _auth0DiscoveryUrl;
    try {
      response = await _httpClient.get(Uri.parse(_discUrl));
    } on Exception {
      log('UIAppAuth: Exception caught whilst attempting endpoint discovery');
      _initialised = false;
      return;
    }

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      _endSessionEndpoint = (json['end_session_endpoint']).toString();
      _userInfoEndpoint = (json['userinfo_endpoint']).toString();
      _initialised = true;
    } else {
      log('UIAppAuth: [${response.statusCode}] - Endpoint: $_auth0DiscoveryUrl');
      _initialised = false;
      return;
    }
  }

  @override
  Future<String> getBearerToken() async {
    if (!_initialised) {
      throw NotInitialisedException();
    }
    if (_refreshToken == null) {
      throw NotLoggedInException();
    }
    // If Access token has expired then update using Refresh token
    var expDateTime = DateTime.parse(_accessTokenExpirationDate!);
    if (DateTime.now().isAfter(expDateTime)) {
      await _refreshAccessToken();
    }
    return _accessToken!;
  }

  @override
  Future<void> login([String? userName, String? password]) async {
    if (!_initialised) {
      if (_auth0DiscoveryUrl.isEmpty) {
        log('UIAppAuth: Login failed - need to initialise AuthService first');
        throw NotInitialisedException();
      } else {
        await _doDiscovery();
      }
    }

    if (userName != null && password != null) {
      await _getTokensUsingOpenIDConnect('grant_type=password&'
          'client_id=$_auth0ClientId&'
          'client_secret=$_auth0ClientSecret&'
          'username=$userName&'
          'password=$password&');
      return;
    }

    AuthorizationTokenResponse? authResult;
    List<String> _promptValues = [];
    if (_requireLogin) {
      _promptValues = ['login'];
      // Perform authorisation code flow with Proof Key for Code Exchange (PKCE)
      final authTokenRequest = AuthorizationTokenRequest(
        _auth0ClientId,
        _auth0RedirectUri,
        issuer: _auth0Issuer,
        scopes: _auth0Scopes,
        promptValues: _promptValues,
      );

      try {
        authResult = await appAuth.authorizeAndExchangeCode(authTokenRequest);
      } on PlatformException {
        throw LoginException();
      }
    } else {
      // If Access token has expired then update using Refresh token
      var expDateTime = DateTime.parse(_accessTokenExpirationDate!);
      if (DateTime.now().isAfter(expDateTime)) {
        await _refreshAccessToken();
        return;
      }
    }

    // Note: Tokens are not held in secure storage.  If the app is restarted
    // then session continuation is prohibited, even if tokens are valid
    _idToken = authResult!.idToken;
    _accessToken = authResult.accessToken;
    _refreshToken = authResult.refreshToken;

    if (_idToken == null || _accessToken == null || _refreshToken == null) {
      log('UIAppAuth: Auth failed, no valid tokens');
      throw LoginException();
    }

    if (authResult.accessTokenExpirationDateTime == null) {
      log('UIAppAuth: No access token expiration in response');
      throw LoginException();
    }
    _accessTokenExpirationDate =
        authResult.accessTokenExpirationDateTime!.toIso8601String();
    log('UIAppAuth: Access Token expiration date: $_accessTokenExpirationDate');

    _auth0IdToken = Auth0IdToken.parseIdToken(_idToken!);
    var _uName = _auth0IdToken!.userName;
    log('username =' + _uName);

    var response = await _performEndpointRequest(Uri.parse(_userInfoEndpoint!));
    user = User.fromJSON(jsonDecode(response));
  }

  @override
  Future<void> logout() async {
    try {
      // Attempt a logout on endpoint
      var endPointLogoutParameter =
          _idToken != null ? idTokenLogoutParameter + _idToken! : '';

      _performEndpointRequest(
          Uri.parse(_endSessionEndpoint! + endPointLogoutParameter));
    } on Exception {
      log('UIAppAuth: Failed to issue logout to endpoint');
    }
    // Invalidate saved tokens and force a login on next authorisation attempt
    _accessToken = null;
    _refreshToken = null;
    _idToken = null;
    _requireLogin = true;
  }

  Future<void> _refreshAccessToken() async {
    TokenResponse? result;

    try {
      result = await appAuth.token(
        TokenRequest(_auth0ClientId, _auth0RedirectUri,
            issuer: _auth0Issuer,
            refreshToken: _refreshToken,
            scopes: _auth0Scopes),
      );
    } catch (e) {
      log('UIAppAuth: ' + e.toString());
    }
    if (result == null) {
      log('UIAppAuth: Failed to refresh access token');
      await login();
    } else {
      _auth0IdToken = Auth0IdToken.parseIdToken(result.idToken!);
      _accessToken = result.accessToken;
      _idToken = result.idToken;
      _accessTokenExpirationDate =
          result.accessTokenExpirationDateTime!.toIso8601String();
    }
  }

  Future<String> _performEndpointRequest(Uri uri) async {
    final response = await _httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $_accessToken',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      log('UIAppAuth: Failed tp action endpoint: ${uri.toString()}');
      throw EndpointAccessException();
    }
  }

  Future<void> _getTokensUsingOpenIDConnect(String formData) async {
    final response = await _httpClient.post(
      Uri.https(
        _auth0Authority,
        _auth0UnencodedPath,
      ),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: formData,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      _accessToken = data[respAccessToken];
      _refreshToken = data[respRefreshToken];
      _idToken = data[respIdToken];
      _accessTokenExpirationDate =
          DateTime.now().add(Duration(seconds: data[respExpiresIn])).toString();
    } else {
      log('UIAppAuth: ${response.body}');
      throw LoginException();
    }
  }
}
