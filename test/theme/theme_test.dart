import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/theme/theme.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('TextTheme', (WidgetTester tester) async {
    late ThemeData theme;
    await tester.pumpApp(
      Builder(
        builder: (BuildContext context) {
          theme = Theme.of(context);
          return Row(children: const [
            Text('A'),
            Icon(
              ECPIcons.cancelCheckout,
            )
          ]);
        },
      ),
    );

    expect(theme.textTheme.bodyText3.color, UiuxColours.primaryTextColor);
    expect(theme.textTheme.bodyText3.fontSize, 12.0);

    expect(theme.textTheme.strikeThoughText.color,
        UiuxColours.voidedListTextColor);
    expect(theme.textTheme.strikeThoughText.fontStyle, FontStyle.italic);
    expect(theme.textTheme.strikeThoughText.fontSize, 14.0);
    expect(theme.textTheme.strikeThoughText.decoration,
        TextDecoration.lineThrough);

    expect(theme.textTheme.strikeThoughCaptionText.color,
        UiuxColours.voidedListTextColor);
    expect(theme.textTheme.strikeThoughCaptionText.fontStyle, FontStyle.italic);
    expect(theme.textTheme.strikeThoughCaptionText.fontSize, 12.0);
    expect(theme.textTheme.strikeThoughCaptionText.decoration,
        TextDecoration.lineThrough);
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byIcon(ECPIcons.cancelCheckout), findsOneWidget);
  });
}
