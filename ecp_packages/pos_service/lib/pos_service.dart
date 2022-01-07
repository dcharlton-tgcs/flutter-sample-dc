import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:auth_service/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/client_context.dart';
import 'package:ecp_openapi/model/ecp_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

part 'cubit/pos_cubit.dart';
part 'cubit/pos_state.dart';
part 'ecp_pos_service.dart';
part 'pos_constants.dart';
part 'pos_exceptions.dart';

abstract class PosService {
  static const MethodChannel _channel = MethodChannel('pos_service');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<Checkout> addItem(
    Checkout checkout,
    String barcode,
    String symbology,
    int quantity,
    String entryMethod,
  );

  Future<Checkout> addPayment(
    Checkout checkout,
    String tenderId,
    double amount,
  );

  Future<Checkout> cancelCheckout(
    Checkout checkout,
  );

  Future<Checkout> changeItemQuantity(
    Checkout checkout,
    String orderItemId,
    int quantity,
  );

  Future<Checkout> finishCheckout(
    Checkout checkout,
  );

  Future<Checkout> startNewCheckout();

  Future<Checkout> voidItem(
    Checkout checkout,
    String orderItemId,
  );
}
