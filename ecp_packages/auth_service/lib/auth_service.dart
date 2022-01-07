import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

part 'auth_exceptions.dart';
part 'cubit/auth_cubit.dart';
part 'cubit/auth_state.dart';
part 'model/user_model.dart';

abstract class AuthService {
  static const MethodChannel _channel = MethodChannel('auth_service');

  static Future<String?> get platformVersion async {
    var version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> initialise(
      Map<String, dynamic> parameters, http.Client httpClient);
  Future<void> login([String? userName, String? password]);
  Future<void> logout();
  User? getActiveUser();
  Future<String> getBearerToken();
}
