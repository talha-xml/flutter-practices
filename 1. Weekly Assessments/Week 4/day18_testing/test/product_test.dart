import 'package:flutter_test/flutter_test.dart';
import 'package:day18_testing/product.dart';

void main() {
  group('applyDiscount', () {
    test('applies a 10% discount', () {
      expect(applyDiscount(1000, 10), 900);
    });

    test('keeps price unchanged with 0% discount', () {
      expect(applyDiscount(1000, 0), 1000);
    });

    test('applies a 50% discount', () {
      expect(applyDiscount(1000, 50), 500);
    });
  });
}
