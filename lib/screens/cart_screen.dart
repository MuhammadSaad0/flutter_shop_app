import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "../provider/cart.dart" show Cart;
import '../widgets/cart_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);
  static const RouteName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItemList = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        "\$${cart.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OrderButton(cart: cart)
                  ]),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cartItemList[i].id,
                cartItemList[i].price,
                cartItemList[i].quantity,
                cartItemList[i].title,
                cart.items.keys.toList()[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        if (widget.cart.items.length != 0) {
          await Provider.of<Orders>(context, listen: false).addOrder(
              widget.cart.items.values.toList(), widget.cart.totalAmount);
          widget.cart.clear();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Order fullfilled!")));
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Something went wrong"),
                    content: Text("Cart is Empty!"),
                    actions: [
                      TextButton(
                        child: Text("Okay"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        }
      },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "Order now",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
    );
  }
}
