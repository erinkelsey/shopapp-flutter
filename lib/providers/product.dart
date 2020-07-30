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

  /// Toggles this product as a favorite for this user.
  ///
  /// Optimistically updates the favorite on the server for user with
  /// [userId] as their unique identifier, and [token] as the
  /// authentication token.
  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    const dbUrl = String.fromEnvironment('FIREBASE_DB_URL');

    final url = '${dbUrl}userFavorites/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(
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
