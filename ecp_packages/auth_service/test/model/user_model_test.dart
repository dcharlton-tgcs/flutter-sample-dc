import 'dart:convert';

import 'package:auth_service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('user empty', () {
    User _user = User.empty;
    expect(_user.firstName, isEmpty);
    expect(_user.lastName, isEmpty);
    expect(_user.emailAddress, isEmpty);
    expect(_user.permissions, isEmpty);
    expect(_user.roles, isEmpty);
    expect(_user.subject, isEmpty);
    expect(_user.userName, isEmpty);
  });

  test('user factory fromJSON', () {
    var testJSON = '''
      {
        "email": "abc@def.com",
        "given_name": "fred",
        "family_name": "bloggs",
        "sub": "0123456789ABC",
        "preferred_username": "bloggo"
      }
    ''';
    var result = User.fromJSON(jsonDecode(testJSON));
    expect(result.emailAddress, "abc@def.com");
    expect(result.firstName, "fred");
    expect(result.lastName, "bloggs");
    expect(result.subject, "0123456789ABC");
    expect(result.userName, "bloggo");
    expect(result.roles, isEmpty);
    expect(result.permissions, isEmpty);
  });
}
