import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';
import "../provider/products_provider.dart";

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsDate = Provider.of<Products>(context);
    final products = productsDate.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductItem(
          products[index].id, products[index].title, products[index].imageUrl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
