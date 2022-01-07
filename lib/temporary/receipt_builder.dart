import 'package:ecp_openapi/model/package.dart';

class ReceiptBuilder {
  static String buildReceipt(final Checkout checkout) {
    var receipt = """
\u001B|cA\u001B|4C
ELERA DEMO\n
\u001B|1C\u001B|lA
==============================================
     Description               P.pc/kg  Amount
==============================================
""";

    var allItems = checkout.posOrder.items as List<OrderItem>;

    var nonLinkedItems = (checkout.posOrder.items as List<OrderItem>)
        .where((item) => item.parentOrderItemId == 'null')
        .toList();
    var currSym = '€';

    for (var item in nonLinkedItems) {
      var _quantity = item.quantity.toString().padLeft(3);
      var _description = item.item.description['default']['text'].padRight(24);
      var _price = (item.unitPrice.toString()).padLeft(8);
      var _total = (item.amount.toString()).padLeft(9);

      receipt += _description + ' ' + _quantity + ' ' + _price + _total;
      receipt += '\r\n';

      if (item.item.linkedItems.isEmpty == false) {
        // Has linked item(s)
        var first = item.item.linkedItems.first;
        var linkedItem = allItems.firstWhere((element) =>
            element.item.catalogItemId == first &&
            element.parentOrderItemId == item.orderItemId);

        _quantity = linkedItem.quantity.toString().padLeft(3);
        _description =
            ('*' + linkedItem.item.description['default']['text']).padLeft(24);
        _price = (linkedItem.unitPrice.toString()).padLeft(8);
        _total = (linkedItem.amount.toString()).padLeft(9);

        receipt += _description + ' ' + _quantity + ' ' + _price + _total;
        receipt += '\r\n';
      }
    }

    receipt += '\r\n';
    receipt += '\u001B|2CTotal' +
        (currSym + ' ' + checkout.posOrder.totals.amount.toString())
            .padLeft(18);
    receipt += '\n\u001B|1C\r\n';
    receipt += '15/11/2021 22:35 POS 1\r\n';
    receipt += 'Order Nr. 12345\n\n';
    receipt += """
\u001B|cA\u001B|bCThank you for your custom!
\u001B|!bC
\n
\u001B|75P

""";

    return receipt;
  }
}
