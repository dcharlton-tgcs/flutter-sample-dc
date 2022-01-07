import 'package:auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/app/app_routing.dart';
import 'package:ui_flutter_app/common_widgets/general_button.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/welcome/welcome.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthSucceeded) {
            BlocProvider.of<PosCubit>(context).setPosCheckoutInitialState();
            Navigator.popAndPushNamed(context, AppRouting.basket);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 5),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  l10n.welcomeErrorLabelText,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Builder(builder: (context) {
            if (state is AuthLoggingIn || state is AuthSucceeded) {
              return Center(
                child: Column(
                  children: const [
                    SizedBox(
                      height: 100,
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          UiuxColours.primaryColour),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 68,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          l10n.welcomeHeadingLabelText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(l10n.welcomeLabelText),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      GeneralButton(
                        key: WelcomePage.loginButtonKey,
                        onPressed: () async {
                          BlocProvider.of<AuthCubit>(context).login();
                        },
                        buttonWidth: 296,
                        buttonHeight: 48,
                        style: ECPButtonStyles.primaryButtonStyle,
                        child: Text(l10n.welcomeLoginButtonText,
                            style:
                                Theme.of(context).textTheme.primaryButtonText),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GeneralButton(
                        key: WelcomePage.onBoardButtonKey,
                        onPressed: () async {},
                        buttonWidth: 296,
                        buttonHeight: 48,
                        style: ECPButtonStyles.secondaryButtonStyle,
                        child: Text(l10n.welcomeOnboardDeviceButtonText,
                            style: Theme.of(context)
                                .textTheme
                                .secondaryButtonText),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48.0),
                    child: GestureDetector(
                      key: WelcomePage.needHelpLinkKey,
                      child: Text(l10n.welcomeNeedHelpLabelText,
                          style:
                              Theme.of(context).textTheme.bodyText2Underlined),
                      onTap: () {},
                    ),
                  )
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
