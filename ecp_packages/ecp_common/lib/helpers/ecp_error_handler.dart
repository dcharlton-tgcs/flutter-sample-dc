part of '../ecp_common.dart';

class EcpErrorHandler {
  static EcpError handleError(int statusCode, String body) {
    log('EcpError: [$statusCode] = $body');

    // statusCode determines type of error received.  For now
    // we're not using but this may be useful in future.
    // https://github.com/tgcs-ecp/ecp-documentation/blob/main/...
    //         platform/api/HTTP-API-guidelines.md

    if (body.isEmpty) {
      return EcpError.empty;
    }

    if (isEcpError(jsonDecode(body))) {
      return EcpError.fromJson(jsonDecode(body));
    }

    return getSpringEcpError(jsonDecode(body));
  }

  static String getPopulatedMessage(EcpError error) {
    var _defaultMessage = error.message.defaultMessage;

    error.message.placeholderValues.forEach((key, value) {
      if (value is Map) {
        _defaultMessage =
            _defaultMessage.replaceAll('\${$key}', value['default']['text']);
      }
      if (value is String) {
        _defaultMessage = _defaultMessage.replaceAll('\${$key}', value);
      }
    });

    return _defaultMessage;
  }

  static bool isEcpError(Map<String, dynamic> json) {
    var _type = json['type'];
    if (_type == null) return false;
    return true;
  }

  static EcpError getSpringEcpError(Map<String, dynamic> json) {
    var _path = json['path'];
    var _error = json['error'];
    var _message =
        'path: ' + _path.toString() + '\nerror: ' + _error.toString();

    return EcpError(
      type: EcpErrorTypeEnum.FAILURE,
      message: EcpMessage(
        key: EcpMessageKey(
          group: 'spring-framework',
          code: json['status'].toString(),
        ),
        defaultMessage: _message,
        placeholderValues: {},
      ),
      attributes: {},
    );
  }
}
