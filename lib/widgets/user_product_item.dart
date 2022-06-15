import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import "package:provider/provider.dart";
import '../provider/products_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  var _deleting = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.imageUrl),
      ),
      trailing: _deleting
          ? Center(
              child: LinearPercentIndicator(
                alignment: MainAxisAlignment.end,
                width: 180,
                animation: true,
                animateFromLastPercent: true,
                lineHeight: 10.0,
                percent: 1,
                animationDuration: 2500,
                backgroundColor: Colors.black,
                progressColor: Colors.red,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => Navigator.of(context).pushNamed(
                        EditProductScreen.routeName,
                        arguments: widget.id),
                    color: Theme.of(context).primaryColor),
                IconButton(
                    icon: Icon(Icons.delete),
                    splashColor: Colors.red,
                    onPressed: () async {
                      try {
                        setState(() {
                          _deleting = true;
                        });
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(widget.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Item deleted")));
                      } catch (error) {
                        setState(() {
                          _deleting = false;
                        });
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Delete failed",
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    color: Theme.of(context).errorColor),
              ],
            ),
    );
  }
}
