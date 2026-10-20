import 'package:flutter/material.dart';

import 'product.dart';

class ProductScreen extends StatefulWidget {
  final List<Product> products;

  const ProductScreen({super.key, required this.products});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool discounted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView(
        children: [
          for (final product in widget.products)
            ListTile(
              title: Text(product.name),
              subtitle: Text(
                'PKR ${discounted ? applyDiscount(product.price, 10).toStringAsFixed(2) : product.price.toStringAsFixed(2)}',
              ),
            ),
          TextButton(
            onPressed: () {
              setState(() => discounted = !discounted);
            },
            child: Text(discounted ? 'Remove discount' : 'Apply 10% discount'),
          ),
        ],
      ),
    );
  }
}
