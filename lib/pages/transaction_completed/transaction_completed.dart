import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/common_widgets/generic_app_bar.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed_view.dart';

class TransactionCompletedPage extends StatelessWidget {
  const TransactionCompletedPage({Key? key}) : super(key: key);

  static const yesButtonKey = Key('transaction_completed_yes_button');
  static const noButtonKey = Key('transaction_completed_no_button');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GenericAppBar(),
        body: BlocBuilder<PosCubit, PosState>(
          builder: (context, state) {
            if (state is PosCheckoutOrderCompleted) {
              return TransactionCompletedView(
                checkout: state.checkout,
              );
            }
            return const Center(
              child: Text(
                'Invalid State',
              ),
            );
          },
        ),
      ),
    );
  }
}
