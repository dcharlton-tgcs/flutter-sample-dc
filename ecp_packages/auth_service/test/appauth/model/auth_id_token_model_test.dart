import 'dart:convert';

import 'package:auth_service/appauth/model/auth_id_token_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty', () {
    Auth0IdToken _user = Auth0IdToken.empty;
    expect(_user.audience, isEmpty);
    expect(_user.emailAddress, isEmpty);
    expect(_user.firstName, isEmpty);
    expect(_user.issuedAt, 0);
    expect(_user.issuer, isEmpty);
    expect(_user.lastName, isEmpty);
    expect(_user.permissions, isEmpty);
    expect(_user.roles, isEmpty);
    expect(_user.subject, isEmpty);
    expect(_user.tokenExpiryTime, 0);
    expect(_user.userName, isEmpty);
  });

  test('parse token', () {
    var token =
        'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJIaklpYXpxd1VQb2pPcWc1NkFJMTE5em1tQ2NfcmJuTjhISk9Mb21GZGpzIn0.eyJleHAiOjE2MzY2NzUwMDMsImlhdCI6MTYzNjYzOTAwMywiYXV0aF90aW1lIjoxNjM2NjM5MDAyLCJqdGkiOiJlZWFkOWZjMC1iMTQyLTQ3NTQtYTBjMS0xMDQ2MzM3MGE1N2MiLCJpc3MiOiJodHRwczovL2tleWNsb2FrLnBsYXRmb3JtLnRvc2hpYmFjb21tZXJjZS5ldS9hdXRoL3JlYWxtcy9FQ1AiLCJhdWQiOiJtb2JpbGUtYXBwIiwic3ViIjoiMDEwMmY0NjYtNTk1NC00NmUwLThhNGEtYjFkYTU1ODlhYWI4IiwidHlwIjoiSUQiLCJhenAiOiJtb2JpbGUtYXBwIiwibm9uY2UiOiJiWi1rcGNMUXIyeExySmtuWU5wVHZRIiwic2Vzc2lvbl9zdGF0ZSI6Ijg5OWNiNjlkLWZmNzctNDU3OC1hYzBjLTE5NTVlODY1MmViNyIsImF0X2hhc2giOiJ0MXFTZi1aTUZtVXFXYU9KZU1OLTVBIiwiYWNyIjoiMSIsInNpZCI6Ijg5OWNiNjlkLWZmNzctNDU3OC1hYzBjLTE5NTVlODY1MmViNyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiTW9iaWxlIERldiIsInByZWZlcnJlZF91c2VybmFtZSI6Im1vYmlsZWRldiIsImdpdmVuX25hbWUiOiJNb2JpbGUiLCJmYW1pbHlfbmFtZSI6IkRldiJ9.SCotLL66iybRV5fjJ2BJHgNYaWlyqMWQFypOhnYjqVUuwahkXE2Mc3nuf_M28fnM1wA7Wldf-ua5muy6bFmWZhhkt9nTU_Rgj-oSoXvoU9JH1hvIE_RvzPBevq8dpjEfGOzYW8sZOUSclkrfuxLzCkpeDJm3';

    var parsed = Auth0IdToken.parseIdToken(token);
    expect(parsed.subject, "0102f466-5954-46e0-8a4a-b1da5589aab8");
  });

  test('factory fromJSON', () {
    var testJSON = '''
      {
        "aud": "audience",
        "email": "abc@def.com",
        "given_name": "fred",
        "iat": 999,
        "iss": "imanissuer",
        "family_name": "bloggs",
        "sub": "0123456789ABC",
        "exp": 12345,
        "preferred_username": "bloggo"
      }
    ''';
    var result = Auth0IdToken.fromJson(jsonDecode(testJSON));
    expect(result.audience, "audience");
    expect(result.emailAddress, "abc@def.com");
    expect(result.firstName, "fred");
    expect(result.issuedAt, 999);
    expect(result.issuer, "imanissuer");
    expect(result.lastName, "bloggs");
    expect(result.permissions, isEmpty);
    expect(result.roles, isEmpty);
    expect(result.subject, "0123456789ABC");
    expect(result.tokenExpiryTime, 12345);
    expect(result.userName, "bloggo");
  });
}
