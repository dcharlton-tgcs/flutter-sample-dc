import 'package:auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/app/app_config.dart';
import 'package:ui_flutter_app/app/app_routing.dart';
import 'package:ui_flutter_app/app/app_utils.dart';
import 'package:ui_flutter_app/common_widgets/general_alert_dialog.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';

class LogoffPage extends StatelessWidget {
  const LogoffPage({Key? key}) : super(key: key);

  static const logoutUsernameKey = Key('logout_username_key');
  static const logoutContainerKey = Key('logout_container_key');

  @override
  Widget build(BuildContext context) {
    final authService = AppConfig.of(context).authService;
    final loggedUser = authService.getActiveUser();
    var currentDayPeriod = AppUtils.dayPeriod;
    for (var element in ItemsListWidget.slidableControllers) {
      element.close();
    }
    return Drawer(
      child: BlocBuilder<PosCubit, PosState>(
        builder: (posContext, posState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 4.0),
                child: Text(
                    currentDayPeriod == DayPeriod.am
                        ? AppLocalizations.of(context)!
                            .morningGreetings(loggedUser!.firstName)
                        : AppLocalizations.of(context)!
                            .afternoonGreetings(loggedUser!.firstName),
                    key: logoutUsernameKey,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
                child: Text(
                  AppLocalizations.of(context)!
                      .userIDLabelText(loggedUser.subject),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        key: logoutContainerKey,
                        margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 7.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 6.0),
                          child: _logoutBody(context, posState),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _logoutBody(BuildContext context, PosState posState) {
    final l10n = context.l10n;
    if (posState is PosCheckoutReady) {
      return InkWell(
        onTap: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (authContext, authState) {
                    return GeneralAlertDialog(
                      label: l10n.logoutLabel,
                      content: l10n.logoutContent,
                      primaryButtonText: l10n.noButtonText,
                      primaryOnPressed: () async {
                        Navigator.pop(context);
                      },
                      secondaryButtonText: l10n.yesButtonText,
                      secondaryOnPressed: () async {
                        BlocProvider.of<PosCubit>(context).cancelCheckout(
                          posState.checkout,
                          true,
                        );

                        BlocProvider.of<AuthCubit>(authContext).logout();

                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRouting.welcome,
                            (Route<dynamic> route) => false);
                      },
                    );
                  },
                );
              });
        },
        child: Container(
          width: 90.0,
          height: 20.0,
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              const Icon(
                ECPIcons.logout,
                size: 20,
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(width: 50, child: Text(l10n.logoutLabel)),
            ],
          ),
        ),
      );
    }
    return InkWell(
        child: Container(
      width: 90.0,
      height: 20.0,
      alignment: Alignment.bottomLeft,
      child: Row(
        children: const [
          SizedBox(
            width: 20,
          ),
        ],
      ),
    ));
  }
}
