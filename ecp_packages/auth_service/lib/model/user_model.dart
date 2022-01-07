part of '../auth_service.dart';

class User {
  const User({
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    required this.permissions,
    required this.roles,
    required this.subject,
    required this.userName,
  });

  final String emailAddress;
  final String firstName;
  final String lastName;
  final List<String> permissions;
  final List<String> roles;
  final String subject;
  final String userName;

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
      emailAddress: (json['email']).toString(),
      firstName: (json['given_name']).toString(),
      lastName: (json['family_name']).toString(),
      permissions: List.empty(),
      roles: List.empty(),
      subject: (json['sub']).toString(),
      userName: (json['preferred_username']).toString(),
    );
  }

  static const empty = User(
    emailAddress: '',
    firstName: '',
    lastName: '',
    permissions: [],
    roles: [],
    subject: '',
    userName: '',
  );
}
