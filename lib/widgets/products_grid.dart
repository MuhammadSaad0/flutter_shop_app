import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';
import "../provider/products_provider.dart";

class ProductsGrid extends StatelessWidget {
  final bool _showOnlyFavourites;
  ProductsGrid(this._showOnlyFavourites);
  @override
  Widget build(BuildContext context) {
    final productsDate = Provider.of<Products>(context);
    final products =
        _showOnlyFavourites ? productsDate.favItems : productsDate.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}
