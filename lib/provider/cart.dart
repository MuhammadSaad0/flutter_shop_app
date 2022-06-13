import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int _count = 0;
    for (var item in _items.entries) {
      _count += item.value.quantity;
    }
    return _count;
  }

  double get totalAmount {
    double _total = 0.0;
    _items.forEach((key, cartItem) {
      _total += cartItem.price * cartItem.quantity;
    });
    return _total;
  }

  void addItem(String productId, double price, String title) {
    _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            price: value.price,
            quantity: value.quantity + 1),
        ifAbsent: () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1));
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (cartitem) => CartItem(
              id: cartitem.id,
              title: cartitem.title,
              price: cartitem.price,
              quantity: cartitem.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
