import 'package:auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/app/app_routing.dart';
import 'package:ui_flutter_app/common_widgets/general_button.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/login/login.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginView> {
  _LoginBodyState();

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSucceeded) {
              BlocProvider.of<PosCubit>(context).setPosCheckoutInitialState();
              Navigator.popAndPushNamed(context, AppRouting.basket);
            }
          },
          builder: (context, state) {
            return Builder(builder: (context) {
              return Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              l10n.usernameLabel,
                              style: ECPTextStyles.loginTextStyleLabels,
                            ),
                          ),
                          Container(
                            width: 296,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: UiuxColours.loginTextFieldsShadowColor,
                                  blurRadius: 8,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              key: LoginPage.loginUserNameTextFieldKey,
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: UiuxColours.whiteBackground,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                              ),
                              style: ECPTextStyles.loginTextStyleLabels,
                              validator: (value) {
                                // TODO: Validate input here
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              l10n.passwordLabel,
                              style: ECPTextStyles.loginTextStyleLabels,
                            ),
                          ),
                          Container(
                            width: 296,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: UiuxColours.loginTextFieldsShadowColor,
                                  blurRadius: 8,
                                  spreadRadius: 0.5,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              key: LoginPage.loginPasswordTextFieldKey,
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: UiuxColours.whiteBackground,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                              style: ECPTextStyles.loginTextStyleLabels,
                              validator: (value) {
                                // TODO: Perform validation here
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: UiuxColours.loginTextFieldsShadowColor,
                          blurRadius: 8,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                    child: GeneralButton(
                      key: LoginPage.loginPageButton,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context).login(
                            _usernameController.text,
                            _usernameController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        textStyle: ECPTextStyles.loginTextStyleLabels,
                        primary: const Color.fromARGB(255, 0, 31, 73),
                      ),
                      buttonWidth: 296,
                      buttonHeight: 48,
                      child: Text(l10n.loginButton),
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
