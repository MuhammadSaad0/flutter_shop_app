import 'package:flutter/material.dart';
import '../provider/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart' as orderitem;
import "../widgets/app_drawer.dart";

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) =>
            orderitem.OrderItem(orderData.orders[index]),
      ),
    );
  }
}
