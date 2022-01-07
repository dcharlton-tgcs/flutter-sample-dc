import 'dart:convert';

class Auth0IdToken {
  const Auth0IdToken({
    required this.audience,
    required this.emailAddress,
    required this.firstName,
    required this.issuedAt,
    required this.issuer,
    required this.lastName,
    required this.permissions,
    required this.roles,
    required this.subject,
    required this.tokenExpiryTime,
    required this.userName,
  });

  final String audience;
  final String emailAddress;
  final String firstName;
  final int issuedAt;
  final String issuer;
  final String lastName;
  final String subject;
  final int tokenExpiryTime;
  final String userName;

  final List<String>? roles;
  final List<String>? permissions;

  static Auth0IdToken parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    );
    return Auth0IdToken.fromJson(json);
  }

  factory Auth0IdToken.fromJson(Map<String, dynamic> json) {
    /*
    TODO: Populate realm/roles
    var _realm = json["realm_access"] as Map<String, dynamic>;
    var _roles = (_realm["roles"] as List<dynamic>).cast<String>();
    var _permissions = List<String>.empty(growable: true);
    var _resources = json["resource_access"] as Map<String, dynamic>;
    for (var e in _resources.entries) {
      for (var p in (e.value["roles"] as List<dynamic>)) {
        _permissions.add("${e.key}.$p");
      }
    }
    */
    var _permissions = List<String>.empty();
    var _roles = List<String>.empty();

    return Auth0IdToken(
      audience: json['aud'] as String,
      emailAddress: (json['email']).toString(),
      firstName: (json['given_name']).toString(),
      issuedAt: json['iat'] as int,
      issuer: (json['iss']).toString(),
      lastName: (json['family_name']).toString(),
      permissions: _permissions,
      roles: _roles,
      subject: (json['sub']).toString(),
      tokenExpiryTime: json['exp'] as int,
      userName: (json['preferred_username']).toString(),
    );
  }

  static const empty = Auth0IdToken(
    audience: '',
    emailAddress: '',
    firstName: '',
    issuedAt: 0,
    issuer: '',
    lastName: '',
    permissions: [],
    roles: [],
    subject: '',
    tokenExpiryTime: 0,
    userName: '',
  );
}
