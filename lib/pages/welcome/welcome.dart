import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/generic_app_bar.dart';
import 'package:ui_flutter_app/pages/welcome/welcome_view.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const loginButtonKey = Key('welcome_keycloak_login_button');
  static const onBoardButtonKey = Key('welcome_onboard_device_button');
  static const needHelpLinkKey = Key('welcome_need_help_link');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Scaffold(
        appBar: GenericAppBar(
          title: Text(l10n.welcomeHeaderPlaceholder),
          titleTextStyle: ECPTextStyles.loginTextStyleLabels,
        ),
        body: const WelcomeView(),
      ),
    );
  }
}
