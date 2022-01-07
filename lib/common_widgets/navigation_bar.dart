import 'package:ecp_openapi/model/entry_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/barcode_keypad.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_peripheral_agent/cubit/scanner_cubit.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  static const scanButtonKey = Key('scan_button');
  static const keypadButtonKey = Key('keypad_button');
  static const settingsButtonKey = Key('settings_button');
  static const basketButtonKey = Key('basket_button');

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 1;

  void setSelectedItem(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  void _showKeypad(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    PosState state = BlocProvider.of<PosCubit>(context).state;

    showModalBottomSheet(
        backgroundColor: UiuxColours.bottomSheetBackground,
        elevation: 10.0,
        barrierColor: Colors.black.withAlpha(10),
        context: context,
        builder: (context) {
          return const BarcodeKeypadSlider();
        }).then((capturedText) {
      String textCaptured = capturedText ?? '';
      if (textCaptured.isNotEmpty && state is PosCheckoutReady) {
        BlocProvider.of<PosCubit>(context).addItem(
          state.checkout,
          textCaptured,
          '',
          1,
          EntryMethod.MANUAL.value,
        );
      }
      setSelectedItem(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0.0,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: GestureDetector(
            key: NavigationBar.settingsButtonKey,
            onTap: () {
              for (var element in ItemsListWidget.slidableControllers) {
                element.close();
              }
            },
            child: Container(
              color: Colors.transparent,
              height: 55.0,
              width: 80.0,
              child: const Icon(
                ECPIcons.settings,
              ),
            ),
          ),
          label: l10n.navbarSettingsButtonText,
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            key: NavigationBar.basketButtonKey,
            onTap: () {
              for (var element in ItemsListWidget.slidableControllers) {
                element.close();
              }
            },
            child: Container(
              color: Colors.transparent,
              height: 55.0,
              width: 80.0,
              child: const Icon(
                ECPIcons.basket,
              ),
            ),
          ),
          label: l10n.navbarBasketButtonText,
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            key: NavigationBar.keypadButtonKey,
            onTap: () {
              for (var element in ItemsListWidget.slidableControllers) {
                element.close();
              }
              setSelectedItem(2);
              _showKeypad(context);
            },
            child: Container(
              color: Colors.transparent,
              height: 55.0,
              width: 80.0,
              child: const Icon(
                ECPIcons.keypad,
              ),
            ),
          ),
          label: l10n.navbarKeypadButtonText,
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            key: NavigationBar.scanButtonKey,
            onLongPressDown: (_) {
              for (var element in ItemsListWidget.slidableControllers) {
                element.close();
              }
              BlocProvider.of<ScannerCubit>(context).enableSoftScan();
            },
            onLongPressUp: () {
              BlocProvider.of<ScannerCubit>(context).disableSoftScan();
            },
            onLongPressCancel: () {
              BlocProvider.of<ScannerCubit>(context).disableSoftScan();
            },
            child: Container(
              color: Colors.transparent,
              height: 55.0,
              width: 80.0,
              child: const Icon(
                ECPIcons.scan,
              ),
            ),
          ),
          label: l10n.navbarScanButtonText,
          tooltip: '',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: UiuxColours.selectedIconNavBar,
      unselectedItemColor: UiuxColours.unselectedIconNavBar,
      backgroundColor: UiuxColours.whiteBackground,
      onTap: (i) {
        for (var element in ItemsListWidget.slidableControllers) {
          element.close();
        }
      },
    );
  }
}
