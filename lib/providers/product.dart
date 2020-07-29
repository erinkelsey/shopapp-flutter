import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Provider class for a product
///
/// Provides a method for toggling this
/// product as a favorite.
class Product with ChangeNotifier {
  /// The id for this product.
  final String id;

  /// The title for this product.
  final String title;

  /// The description for this product.
  final String description;

  /// The price for this product.
  final double price;

  /// The URL for the location of the image for this product.
  final String imageUrl;

  /// Boolean for determining if this product is a favorite.
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  /// Toggles this product as a favorite.
  ///
  /// Optimistically updates the favorite on the server.
  Future<void> toggleFavoriteStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://shop-app-flutter-e7a32.firebaseio.com/products/$id.json?auth=$token';

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
