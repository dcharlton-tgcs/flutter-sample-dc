import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_flutter_app/app/app_config.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

class LaunchView extends StatefulWidget {
  const LaunchView({Key? key}) : super(key: key);

  @override
  State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {
  bool printerClaimed = false;
  bool scannerClaimed = false;

  bool sessionOpenRequested = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appConfig = AppConfig.of(context);
    final l10n = context.l10n;

    var peripheralCubit = BlocProvider.of<PeripheralCubit>(context);
    var printerCubit = BlocProvider.of<PrinterCubit>(context);
    var scannerCubit = BlocProvider.of<ScannerCubit>(context);

    peripheralCubit.listenForEvents();
    printerCubit.listenForEvents();
    scannerCubit.listenForEvents();

    if (!sessionOpenRequested) {
      sessionOpenRequested = true;

      peripheralCubit.openSession(
        appConfig.peripheralSessionId,
        [
          appConfig.printerIdentifier,
          appConfig.scannerIdentifier,
        ],
      );
    }

    _popAndGoToWelcome(context) {
      if (printerClaimed && scannerClaimed) {
        Navigator.popAndPushNamed(context, AppConfig.of(context).initialRoute);
      }
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<PrinterCubit, PeripheralState>(
            listener: (printerContext, printerState) async {
          if (printerState is PeripheralOpened) {
            printerCubit.claimPeripheral();
          } else if (printerState is PeripheralClaimed) {
            printerClaimed = true;
            _popAndGoToWelcome(context);
          }
        }),
        BlocListener<ScannerCubit, PeripheralState>(
            listener: (scannerContext, scannerState) async {
          if (scannerState is PeripheralOpened) {
            scannerCubit.claimPeripheral();
          } else if (scannerState is PeripheralClaimed) {
            scannerClaimed = true;
            scannerCubit.enablePeripheral();
            _popAndGoToWelcome(context);
          }
        }),
        BlocListener<PeripheralCubit, PeripheralState>(
            listener: (paContext, paState) async {
          if (paState is SessionOpened) {
            printerCubit.openPeripheral();
            scannerCubit.openPeripheral();
          }
        }),
      ],
      child: Scaffold(
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
                        l10n.launchScreenText,
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
      ),
    );
  }
}
