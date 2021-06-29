import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as https;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final double discount;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      @required this.discount,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await https.put(Uri.parse(url),
          body: json.encode(
            isFavorite,
          ));

      //notifyListeners();
      print(response.body);

      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (_) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
