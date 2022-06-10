import 'package:flutter/material.dart';
import '../provider/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart' as orderitem;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) =>
            orderitem.OrderItem(orderData.orders[index]),
      ),
    );
  }
}