import "package:flutter/foundation.dart";
import 'package:flutter_complete_guide/models/http_exception.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
        "https://flutter-shop-app-46124-default-rtdb.asia-southeast1.firebasedatabase.app/userFavourites/$userId/$id.json?auth=${token}");
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
        throw HttpException("Item could not be added to favourites");
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
      throw error;
    }
  }

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavourite: isFavorite ?? this.isFavourite,
    );
  }
}
