import 'package:flutter/foundation.dart';

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

  /// Method for toggling this product as a favorite
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
