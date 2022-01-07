import 'dart:math';

import 'package:auth_service/auth_service.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: avoid_print
// Fake implementation of imaginary authorisation service :)
class FakeAuthService extends AuthService {
  static const List<String> firstNames = [
    'Adam',
    'Andre',
    'Andrew',
    'Andy',
    'Henri',
    'Kibla',
    'Mariska',
    'Mary Beth',
    'Raluca',
    'Vali',
    'Charlie',
    'Jo',
    'Gijs',
    'Fabien',
  ];

  static const List<String> lastNames = [
    'the Menace',
    'the Duck',
    'Brown',
    'Mouse',
    'Bunny',
    'Dolittle',
    'Bear',
    'Little',
    'the Great',
  ];

  @override
  Future<User> login([String? userName, String? password]) async {
    print('FakeAuthService: login($userName)');
    var rand = Random();
    if (password!.length < 4) {
      print('FakeAuthService: login failed');
      throw LoginException();
    }

    User fakeUser = User(
      firstName: firstNames[rand.nextInt(firstNames.length - 1)],
      lastName: lastNames[rand.nextInt(lastNames.length - 1)],
      userName: userName!,
      emailAddress: '$userName@tgcs.demo',
      subject: 'abcd',
      roles: [],
      permissions: [],
    );
    print('FakeAuthService: logged in as ${fakeUser.firstName} '
        '${fakeUser.lastName}');

    await Future.delayed(const Duration(seconds: 1));

    return fakeUser;
  }

  @override
  Future<bool> initialise(Map<String, dynamic> parameters,
      [http.Client? httpClient]) async {
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  User? getActiveUser() {
    return user;
  }

  @override
  Future<String> getBearerToken() async {
    return 'NoTokenForFakeAuth';
  }

  User? user = const User(
    firstName: 'Andreas',
    lastName: 'Doe',
    emailAddress: 'andreas.doe@domain.com',
    permissions: ['admin', 'user'],
    roles: ['changeItemQuantity', 'manager'],
    subject: '1q2w3e',
    userName: 'andreas.doe',
  );
}
