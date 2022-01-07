import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';

class SlidableControllerSender extends StatefulWidget {
  const SlidableControllerSender({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _SlidableControllerSenderState createState() =>
      _SlidableControllerSenderState();
}

class _SlidableControllerSenderState extends State<SlidableControllerSender> {
  late SlidableController controller;

  @override
  void initState() {
    super.initState();
    controller = Slidable.of(context)!;
    ItemsListWidget.slidableControllers.add(controller);
  }

  @override
  void dispose() {
    ItemsListWidget.slidableControllers.remove(controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
