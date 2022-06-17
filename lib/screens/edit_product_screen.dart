import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/splash_screen.dart';
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

  var _isInit = true;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void dispose() {
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
      super.dispose();
    }

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
      }
    }
    _isInit = false;

    Future<void> _saveForm() async {
      // _form.currentState.validate();
      _form.currentState.save();

      if (_editedProduct.id == null && _form.currentState.validate()) {
        try {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          setState(() {
            _isLoading = false;
          });
          await showDialog<Null>(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text("An Error occurred"),
                    content: Text("Something went wrong"),
                    actions: [
                      TextButton(
                        child: Text("Okay"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        } finally {
          Navigator.of(context).pop();
        }
      } else if (_form.currentState.validate()) {
        _isLoading = true;
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);

        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? Center(
              child: SplashScreen(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                      initialValue: "${_editedProduct.title}",
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
                      initialValue: "${_editedProduct.price}",
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
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
                      initialValue: "${_editedProduct.description}",
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct =
                            _editedProduct.copyWith(description: value);
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
                          initialValue: "${_editedProduct.imageUrl}",
                          decoration: InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (input) {
                            setState(() {
                              _imageUrlInput = input;
                            });
                          },
                          onSaved: (value) {
                            _editedProduct =
                                _editedProduct.copyWith(imageUrl: value);
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
