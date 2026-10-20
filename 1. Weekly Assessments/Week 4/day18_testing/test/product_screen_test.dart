import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:day18_testing/product.dart';
import 'package:day18_testing/product_screen.dart';

void main() {
  testWidgets('displays products and applies a discount', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductScreen(products: [Product(name: 'Keyboard', price: 3000)]),
      ),
    );

    expect(find.text('Keyboard'), findsOneWidget);
    expect(find.text('PKR 3000.00'), findsOneWidget);

    await tester.tap(find.text('Apply 10% discount'));
    await tester.pump();

    expect(find.text('PKR 2700.00'), findsOneWidget);
    expect(find.text('Remove discount'), findsOneWidget);
  });
}
