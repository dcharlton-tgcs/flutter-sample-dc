import 'package:ecp_openapi/model/package.dart';

class ModelHelper {
  static final emptyMetadata = Metadata(
    modelVersion: '',
    entityVersion: 0,
    creationTimestamp: DateTime.parse('2021-08-01 10:10:00'),
    lastModificationTimestamp: DateTime.parse('2021-08-01 10:10:00'),
    lastModificationUser: '',
  );

  static const emptyOrderState = (OrderState.CHECKOUT);
}
