import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:day18_testing/product.dart';
import 'package:day18_testing/product_repository.dart';

class MockProductDataSource extends Mock implements ProductDataSource {}

void main() {
  late MockProductDataSource dataSource;
  late ProductRepository repository;

  setUp(() {
    dataSource = MockProductDataSource();
    repository = ProductRepository(dataSource);
  });

  test('returns products from the data source', () async {
    final products = [
      const Product(name: 'Keyboard', price: 3000),
      const Product(name: 'Mouse', price: 1500),
    ];

    when(() => dataSource.fetchProducts()).thenAnswer((_) async => products);

    final result = await repository.getProducts();

    expect(result.length, 2);
    expect(result.first.name, 'Keyboard');
    verify(() => dataSource.fetchProducts()).called(1);
  });

  test('propagates a data source failure', () async {
    when(() => dataSource.fetchProducts())
        .thenAnswer((_) => Future.error(Exception('Failed to fetch')));

    expect(repository.getProducts(), throwsA(isA<Exception>()));
  });
}
