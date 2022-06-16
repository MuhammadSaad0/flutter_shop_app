import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth.dart';
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
import "./screens/auth_screen.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(null, [], null),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(null, []),
            update: (ctx, auth, previousOrders) => Orders(auth.token,
                previousOrders == null ? [] : previousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Shop',
            theme: ThemeData(
              fontFamily: "Lato",
              primarySwatch: Colors.purple,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.deepOrange),
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailsScreen.routeName: ((context) =>
                  ProductDetailsScreen()),
              CartScreen.RouteName: ((context) => CartScreen()),
              OrdersScreen.routeName: ((context) => OrdersScreen()),
              UserProducts.routeName: ((context) => UserProducts()),
              EditProductScreen.routeName: ((context) => EditProductScreen()),
            },
          ),
        ));
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
