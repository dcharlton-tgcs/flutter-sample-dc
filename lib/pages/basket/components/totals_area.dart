import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/pos_order.dart';
import 'package:flutter/material.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';

/* *************************************************

this is placeholder - will need to change to proper component

**************************************************** */

class TotalsAreaWidget extends StatelessWidget {
  const TotalsAreaWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  final PosOrder order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final _total = UiuxNumber.currency(order.totals.amount);
    return SizedBox(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '${l10n.basketTotalsItemslabelText}'
              '${' '}${order.totals.totalItemQuantity}',
              textAlign: TextAlign.start,
              style: textTheme.subtitle2,
            ),
          ),
          Expanded(
            child: Text(
              order.totals.amount < 0
                  ? '${l10n.basketTotalsTotallabelText} ' '$_total'
                  : '${l10n.basketTotalsTotallabelText}' '$_total',
              textAlign: TextAlign.end,
              style: textTheme.subtitle2,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
