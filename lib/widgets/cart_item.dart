import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  CartItem(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    var total = widget.price * widget.quantity;
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            barrierColor: Color.fromRGBO(0, 0, 0, 0.6),
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    "Are you sure?",
                  ),
                  content:
                      Text("Do you want to remove the item from the cart?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text("Yes"),
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(widget.productId);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: FittedBox(
                  child: Text(
                    "\$${widget.price}",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            title: Text(widget.title),
            subtitle: Text("Total: \$${total.toStringAsFixed(2)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => Provider.of<Cart>(context, listen: false)
                        .removeSingleItem(widget.productId),
                    icon: Icon(Icons.remove)),
                Text("${widget.quantity}x"),
                IconButton(
                    onPressed: () => Provider.of<Cart>(context, listen: false)
                        .addSingleItem(widget.productId),
                    icon: Icon(Icons.add)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
