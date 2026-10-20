class Product {
  final String name;
  final double price;

  const Product({required this.name, required this.price});
}

double applyDiscount(double price, double discountPercent) {
  return price - (price * discountPercent / 100);
}
