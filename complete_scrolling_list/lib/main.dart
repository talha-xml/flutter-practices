import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Electronics Store"), centerTitle: true),
        body: ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          products[index]["name"]!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          products[index]["description"]!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          products[index]["price"]!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: (){}, child: Text("Buy")),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

List<Map<String, String>> products = [
  {"name": "iPhone 15", "description": "Premium smartphone", "price": "\$799"},
  {"name": "Samsung Galaxy", "description": "Android", "price": "\$699"},
  {"name": "MacBook", "description": "Lightweight laptop", "price": "\$999"},
  {"name": "Dell Laptop", "description": "Business laptop", "price": "\$849"},
  {"name": "AirPods", "description": "Wireless earbuds", "price": "\$199"},
  {"name": "Apple Watch", "description": "Smart wearable", "price": "\$399"},
  {"name": "iPad", "description": "Portable tablet", "price": "\$499"},
];
