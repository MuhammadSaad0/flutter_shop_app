import 'package:flutter/material.dart';
import '../provider/product.dart';
import "../provider/products_provider.dart";
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);
  static const routeName = "/editproduct-screen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  String _imageUrlInput;
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: "", price: 0, description: "", imageUrl: "");

  @override
  Widget build(BuildContext context) {
    void dispose() {
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
      super.dispose();
    }

    void _saveForm() {
      _form.currentState.validate();
      _form.currentState.save();
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(title: value);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide a title";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct =
                      _editedProduct.copyWith(price: double.parse(value));
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide a price";
                  } else if (double.tryParse(value) == null) {
                    return "Invalid price";
                  } else if (double.parse(value) <= 0) {
                    return "Enter a price greater than zero";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(description: value);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide a description";
                  } else if (value.length < 10) {
                    return "Description should be at least 10 characters long";
                  }
                  return null;
                },
              ),
              SizedBox(width: 30, height: 30),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Image URL"),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    onChanged: (input) {
                      setState(() {
                        _imageUrlInput = input;
                      });
                    },
                    onSaved: (value) {
                      _editedProduct = _editedProduct.copyWith(imageUrl: value);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please provide an image url";
                      } else if (!value.startsWith("http")) {
                        return "Enter valid image url";
                      }
                      return null;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    height: 240,
                    margin: EdgeInsets.only(top: 30, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlInput == null
                        ? FittedBox(
                            child: Image.network(
                              "https://us.123rf.com/450wm/koblizeek/koblizeek2001/koblizeek200100006/137486703-no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-.jpg?ver=6",
                              fit: BoxFit.fill,
                            ),
                          )
                        : FittedBox(
                            child: Image.network(
                              _imageUrlInput,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
