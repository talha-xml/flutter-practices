import 'product.dart';

abstract class ProductDataSource {
  Future<List<Product>> fetchProducts();
}

class ProductRepository {
  final ProductDataSource dataSource;

  ProductRepository(this.dataSource);
  Future<List<Product>> getProducts() {
    return dataSource.fetchProducts();
  }
}
