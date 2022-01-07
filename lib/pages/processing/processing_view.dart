import 'package:flutter/material.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class ProcessingView extends StatelessWidget {
  const ProcessingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.processingScreenText,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          UiuxColours.primaryColour),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox(
                  height: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
