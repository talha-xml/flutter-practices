import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:day18_testing/product.dart';
import 'package:day18_testing/product_screen.dart';

void main() {
  testWidgets('product screen matches golden image', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductScreen(products: [Product(name: 'Keyboard', price: 3000)]),
      ),
    );

    await expectLater(
      find.byType(ProductScreen),
      matchesGoldenFile('goldens/product_screen.png'),
    );
  });
}
