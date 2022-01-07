import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/quantity_keypad.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class ItemsListWidget extends StatefulWidget {
  const ItemsListWidget({
    Key? key,
    required this.checkout,
  }) : super(key: key);

  final Checkout checkout;
  static const quantityTextKey = Key('item_quantity_text_key');
  static const descTextKey = Key('item_desc_text_key');
  static const unitPriceTextKey = Key('item_unit_price_text_key');
  static const priceTextKey = Key('item_price_text_key');
  static const linkedItemPriceKey = Key('linked_item_price_key');
  static const itemContainerKey = Key('item_container_key');
  static const listScrollbarKey = Key('list_scrollbar_key');

  static Set<SlidableController> slidableControllers = <SlidableController>{};

  @override
  _ItemsListWidgetState createState() => _ItemsListWidgetState();
}

class _ItemsListWidgetState extends State<ItemsListWidget>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  final String _groupTag = 'itemsListGroup';

  final String _slidableKey = 'slidableKey';
  final String _quantityPadKey = 'quantityPadKey';

  @override
  void initState() {
    super.initState();
  }

  void _showKeypad(BuildContext context, Checkout checkout, int index,
      [int? maximumQuantity]) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    var nonLinkedItems = (checkout.posOrder.items as List<OrderItem>)
        .where((item) => item.parentOrderItemId == 'null')
        .toList();
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: UiuxColours.bottomSheetBackground,
        elevation: 10.0,
        barrierColor: Colors.black.withAlpha(10),
        context: context,
        builder: (context) {
          return QuantityKeypadSlider(
            order: checkout.posOrder,
            index: index,
            maximumQuantity: maximumQuantity,
            onClickAction: (String s) => {
              BlocProvider.of<PosCubit>(context).changeItemQuantity(
                checkout,
                nonLinkedItems[index].orderItemId,
                int.parse(s),
              )
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: _listView(context),
        ),
      ),
    );
  }

  SlidableNotificationListener _listView(BuildContext context) {
    final l10n = context.l10n;
    var nonLinkedItems = (widget.checkout.posOrder.items as List<OrderItem>)
        .where((item) => item.parentOrderItemId == 'null')
        .toList();
    return SlidableNotificationListener(
      onNotification: (notification) {
        if (notification is SlidableRatioNotification) {
          setState(() {});
        }
      },
      child: ListView.builder(
        key: ItemsListWidget.listScrollbarKey,
        controller: _scrollController,
        itemCount: nonLinkedItems.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          var _itemVoided = nonLinkedItems[index].voided;

          return Column(
            children: [
              Slidable(
                key: Key(_slidableKey + index.toString()),
                groupTag: _groupTag,
                //left side of slidable
                startActionPane: null,

                //right side of slidable
                endActionPane: _itemVoided
                    ? null
                    : ActionPane(
                        extentRatio: 0.244,
                        motion: const StretchMotion(),
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                                textTheme: const TextTheme(
                              button: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                            child: SlidableAction(
                              flex: 1,
                              onPressed: (_) async {
                                await _voidItem(
                                  widget.checkout,
                                  nonLinkedItems[index].orderItemId,
                                );
                              },
                              backgroundColor: UiuxColours.slidableDeleteColour,
                              label: l10n.slidableDeleteText,
                            ),
                          ),
                        ],
                      ),
                // What is shown when the slidable is not dragged.
                child: SlidableControllerSender(
                  child: _item(
                    context,
                    index,
                  ),
                ),
              ),
              Container(
                height: 1.0,
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                color: _itemVoided ? UiuxColours.voidedBackgroundColour : null,
                child: const Divider(
                  color: UiuxColours.dividerColor,
                  height: 1.0,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Column _item(
    BuildContext context,
    int index,
  ) {
    var nonLinkedItems = (widget.checkout.posOrder.items as List<OrderItem>)
        .where((item) => item.parentOrderItemId == 'null')
        .toList();
    var _quantity = nonLinkedItems[index].quantity;
    var _itemDescription =
        nonLinkedItems[index].item.description['default']['text'];
    var _price = UiuxNumber.currency(
      nonLinkedItems[index].amount,
    );
    var _unitPrice = UiuxNumber.currency(
      nonLinkedItems[index].unitPrice,
    );
    var _itemVoided = nonLinkedItems[index].voided;

    var _ratio = 0.0;

    if (ItemsListWidget.slidableControllers.length > index) {
      _ratio = ItemsListWidget.slidableControllers.elementAt(index).ratio;
    }

    var leftPadding = MediaQuery.of(context).size.width * -(_ratio);
    var _itemHasLinkedItems =
        nonLinkedItems[index].item.linkedItems.isEmpty ? false : true;

    late OrderItem linkedItem;
    if (_itemHasLinkedItems == true) {
      var _itemLinkedItems = nonLinkedItems[index].item.linkedItems.first;
      linkedItem = (widget.checkout.posOrder.items as List<OrderItem>)
          .firstWhere((element) =>
              element.item.catalogItemId == _itemLinkedItems &&
              element.parentOrderItemId == nonLinkedItems[index].orderItemId);
    }

    return Column(
      children: [
        Container(
          key: ItemsListWidget.itemContainerKey,
          padding: EdgeInsets.only(
            left: _ratio < -0.11 ? leftPadding : 16.0,
            right: 16.0,
          ),
          height: 60.0,
          color: _itemVoided ? UiuxColours.voidedBackgroundColour : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ratio > -0.11
                  ? _quantityBody(
                      context,
                      widget.checkout,
                      index,
                      _quantity,
                    )
                  : const Material(),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _itemDescription,
                      key: ItemsListWidget.descTextKey,
                      textAlign: TextAlign.start,
                      style: _itemVoided
                          ? Theme.of(context)
                              .textTheme
                              .strikeThoughItemDescriptionText
                          : Theme.of(context)
                              .textTheme
                              .normalItemDescriptionText,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      _unitPrice,
                      key: ItemsListWidget.unitPriceTextKey,
                      textAlign: TextAlign.start,
                      style: _itemVoided
                          ? Theme.of(context).textTheme.strikeThoughCaptionText
                          : Theme.of(context).textTheme.bodyText3,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              _ratio > -0.11
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      verticalDirection: VerticalDirection.down,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 70.0,
                            child: Text(
                              _price,
                              key: ItemsListWidget.priceTextKey,
                              textAlign: TextAlign.end,
                              style: _itemVoided
                                  ? Theme.of(context).textTheme.strikeThoughText
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Flexible(
                          child: Text(
                            _itemHasLinkedItems
                                ? linkedItem.item.description['default']
                                        ['text'] +
                                    ': +' +
                                    UiuxNumber.currency(
                                        linkedItem.unitPrice * _quantity)
                                : '',
                            key: ItemsListWidget.linkedItemPriceKey,
                            textAlign: TextAlign.end,
                            style: _itemVoided
                                ? Theme.of(context)
                                    .textTheme
                                    .strikeThoughTextLinkedItem
                                : Theme.of(context)
                                    .textTheme
                                    .linkedItemPriceTextStyle,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Material _quantityBody(
    BuildContext context,
    Checkout checkout,
    int index,
    num quantity,
  ) {
    var nonLinkedItems = (checkout.posOrder.items as List<OrderItem>)
        .where((item) => item.parentOrderItemId == 'null')
        .toList();
    bool _quantityChangedAllowed =
        nonLinkedItems[index].item.quantityChangeAllowed;
    var _itemVoided = nonLinkedItems[index].voided;
    if (_quantityChangedAllowed && !_itemVoided) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: UiuxColours.quantityBackgroundColour,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            key: Key(_quantityPadKey + index.toString()),
            onTap: () => {
              _showKeypad(
                context,
                checkout,
                index,
                999,
              )
            },
            child: Container(
              width: 24.0,
              height: 24.0,
              alignment: Alignment.center,
              child: Text(
                '$quantity',
                key: ItemsListWidget.quantityTextKey,
              ),
            ),
          ),
        ),
      );
    }
    return Material(
        color: Colors.transparent,
        child: Container(
          key: Key(_quantityPadKey + index.toString()),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: _itemVoided
                ? UiuxColours.quantityVoidedBackgroundColour
                : UiuxColours.whiteBackground,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            '$quantity',
            key: ItemsListWidget.quantityTextKey,
            style: _itemVoided
                ? Theme.of(context).textTheme.strikeThoughText
                : null,
          ),
        ));
  }

  Future<void> _voidItem(
    Checkout checkout,
    String orderItemId,
  ) async {
    await BlocProvider.of<PosCubit>(context).voidItemCheckout(
      checkout,
      orderItemId,
    );
  }
}
