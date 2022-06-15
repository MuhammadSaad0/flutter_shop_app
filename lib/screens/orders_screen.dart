import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../provider/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart' as orderitem;
import "../widgets/app_drawer.dart";

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);
  static const routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context, listen: false).FetchAndSetOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Orders>(context, listen: false).FetchAndSetOrders(),
        child: orderData.orders.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: CachedNetworkImage(
                    imageUrl:
                        "https://www.no-fea.com/front/images/empty-cart.png",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/");
                      },
                      child: Text("Shop Now!"))
                ],
              )
            : ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, index) =>
                    orderitem.OrderItem(orderData.orders[index]),
              ),
      ),
    );
  }
}
