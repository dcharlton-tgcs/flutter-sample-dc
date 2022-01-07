import 'package:auth_service/appauth/app_auth_service.dart';
import 'package:auth_service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_auth_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  var epResponse = '''
  {
      "end_session_endpoint":"i_am_end_session",
      "userinfo_endpoint":"i_am_userinfo"
  }        
  ''';

  var keycloakResponse = '''
  {
      "access_token": "accesstoken",
      "expires_in": 36000,
      "refresh_expires_in": 1800,
      "refresh_token": "refreshtoken",
      "token_type": "Bearer",
      "not-before-policy": 0,
      "session_state": "ff86b477-b399-449d-94f5-7d756c4858df",
      "scope": "profile email"
  }
  ''';

  var keycloakErrorResponse = '''
  {
      "error": "invalid_grant",
      "error_description": "Invalid user credentials"
  }
  ''';

  var domain = 'my.domain';
  var authority = 'my.authority';
  var discoveryUrl = 'openid-configuration';
  var clientId = 'a-client-id';
  var bundleId = 'a.bundle.id';
  var scopes = ['scope1', 'scope2', 'scope3', 'scope4'];
  var clientsecret = 'secret';
  var unencodedPath = 'a/unencoded/path';

  Map<String, dynamic> authParams = {
    AppAuthService.auth0DiscoveryUrl: discoveryUrl,
    AppAuthService.auth0Authority: authority,
    AppAuthService.auth0Domain: domain,
    AppAuthService.auth0ClientId: clientId,
    AppAuthService.auth0BundleId: bundleId,
    AppAuthService.auth0Scopes: scopes,
    AppAuthService.auth0ClientSecret: clientsecret,
    AppAuthService.auth0UnencodedPath: unencodedPath,
  };

  late http.Client _httpClient;

  setUpAll(() {
    _httpClient = MockClient();
  });

  group('general:', () {
    test('active user empty', () async {
      var appAuthService = AppAuthService();
      var user = appAuthService.getActiveUser();
      expect(user, isInstanceOf<User?>());
    });
  });

  group('initialisation:', () {
    test('initialisation fails on bad endpoint', () async {
      // Match up request for discovery
      when(
        _httpClient.get(Uri.https(domain, discoveryUrl)),
      ).thenAnswer((_) async {
        // Provide a bad response
        return http.Response('error', 404);
      });

      var appAuthService = AppAuthService();

      try {
        bool result = await appAuthService.initialise(authParams, _httpClient);
        if (result) {
          fail('Unexpected result - success');
        }
      } catch (e) {
        fail('Exception thrown when none expected');
      }
    });
    test('discovery of endpoints succeeds and results parsed', () async {
      var epResponse = '''
        {
          "end_session_endpoint":"i_am_end_session",
          "userinfo_endpoint":"i_am_userinfo"
        }        
      ''';
      // Match up request for discovery
      when(
        _httpClient.get(Uri.https(domain, discoveryUrl)),
      ).thenAnswer((_) async {
        // Provide a valid response
        return http.Response(epResponse, 200);
      });

      var appAuthService = AppAuthService();

      try {
        if (false == await appAuthService.initialise(authParams, _httpClient)) {
          fail('Expected login to pass');
        }
      } catch (e) {
        fail('Exception thrown when none expected - ${e.toString()}');
      }
    });
  });

  group('logging in:', () {
    setUpAll(() async {
      // Clear out any existing initialisation
      when(
        _httpClient.get(Uri.https(domain, discoveryUrl)),
      ).thenAnswer((_) async {
        // Provide a bad response
        return http.Response('error', 404);
      });

      var appAuthService = AppAuthService();

      try {
        await appAuthService.initialise(authParams, _httpClient);
      } catch (e) {
        expect(e, isInstanceOf<EndpointAccessException>());
      }
    });

    // test('login requires initialisation', () async {
    //   try {
    //     await AppAuthService().login();
    //   } catch (e) {
    //     expect(e, isA<NotInitialisedException>());
    //   }
    // });

    test('login with username and password', () async {
      when(
        _httpClient.get(Uri.https(domain, discoveryUrl)),
      ).thenAnswer((_) async {
        // Provide a valid response
        return http.Response(epResponse, 200);
      });

      var appAuthService = AppAuthService();

      await appAuthService.initialise(authParams, _httpClient);
      when(
        _httpClient.post(Uri.https(authority, unencodedPath),
            headers: anyNamed('headers'),
            body: 'grant_type=password&'
                'client_id=$clientId&'
                'client_secret=$clientsecret&'
                'username=abc&'
                'password=abc&'),
      ).thenAnswer((_) async {
        // Provide a valid response
        return http.Response(keycloakResponse, 200);
      });

      await appAuthService.login('abc', 'abc');

      expect(await appAuthService.getBearerToken(), 'accesstoken');
    });

    test('login with username and password results in error', () async {
      when(
        _httpClient.get(Uri.https(domain, discoveryUrl)),
      ).thenAnswer((_) async {
        // Provide a valid response
        return http.Response(epResponse, 200);
      });

      var appAuthService = AppAuthService();

      await appAuthService.initialise(authParams, _httpClient);
      when(
        _httpClient.post(Uri.https(authority, unencodedPath),
            headers: anyNamed('headers'),
            body: 'grant_type=password&'
                'client_id=$clientId&'
                'client_secret=$clientsecret&'
                'username=abc&'
                'password=abc&'),
      ).thenAnswer((_) async {
        // Provide a valid response
        return http.Response(keycloakErrorResponse, 400);
      });

      try {
        await appAuthService.login('abc', 'abc');
      } catch (e) {
        expect(e, isA<LoginException>());
      }
    });
  });

  // group('logging out:', () {
  //   test('logout calls endpoint', () async {
  //     //
  //     when(
  //       _httpClient.get(Uri.https(domain, discoveryUrl)),
  //     ).thenAnswer((_) async {});
  //   });
  // });
}
