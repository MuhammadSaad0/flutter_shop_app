import 'package:flutter/material.dart';
import '../screens/user_products.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Hello Friend"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop_2),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage Products"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProducts.routeName);
          },
        )
      ]),
    );
  }
}
