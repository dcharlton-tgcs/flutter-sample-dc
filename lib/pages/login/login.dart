import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/generic_app_bar.dart';
import 'package:ui_flutter_app/pages/login/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const loginUserNameTextFieldKey = Key('login_username_text_field');
  static const loginPasswordTextFieldKey = Key('login_password_text_field');
  static const loginPageButton = Key('login_page_button');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GenericAppBar(),
        body: const LoginView(),
      ),
    );
  }
}
