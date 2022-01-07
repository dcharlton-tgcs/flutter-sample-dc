import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/generic_app_bar.dart';
import 'package:ui_flutter_app/pages/processing/processing_view.dart';

class ProcessingPage extends StatelessWidget {
  const ProcessingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GenericAppBar(),
        body: const ProcessingView(),
      ),
    );
  }
}
