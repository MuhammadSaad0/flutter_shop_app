import 'package:flutter/material.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import "package:provider/provider.dart";
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './provider/products_provider.dart';
import "./provider/cart.dart";
import "./screens/cart_screen.dart";
import "./provider/orders.dart";
import './screens/user_products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop',
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.purple,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: ((context) => ProductDetailsScreen()),
          CartScreen.RouteName: ((context) => CartScreen()),
          OrdersScreen.routeName: ((context) => OrdersScreen()),
          UserProducts.routeName: ((context) => UserProducts()),
          EditProductScreen.routeName: ((context) => EditProductScreen()),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: const Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
