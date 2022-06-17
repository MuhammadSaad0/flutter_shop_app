import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String _authToken;
  final String userId;
  Products(this._authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    final url = Uri.parse(
        'https://flutter-shop-app-46124-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$_authToken&$filterString');

    print(url);
    try {
      final response = await http.get(url);
      print(userId);
      print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null || extractedData["error"] != null) {
        return;
      }
      final favurl = Uri.parse(
          "https://flutter-shop-app-46124-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourites/$userId.json?auth=${_authToken}");
      final favResponse = await http.get(favurl);
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavourite: favData == null ? false : favData[prodId] ?? false,
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void setItems(loadedProducts) {
    _items = loadedProducts;
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://flutter-shop-app-46124-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=${_authToken}");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "creatorId": userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)["name"],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url = Uri.parse(
        "https://flutter-shop-app-46124-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=${_authToken}");
    await http.patch(url,
        body: json.encode({
          "title": newProduct.title,
          "description": newProduct.description,
          "imageUrl": newProduct.imageUrl,
          "price": newProduct.price,
        }));
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://flutter-shop-app-46124-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=${_authToken}");
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    try {
      await http.delete(url).then((response) {
        if (response.statusCode >= 400) {
          throw HttpException("Could not delete item");
        }
      });
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw error;
    }
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
