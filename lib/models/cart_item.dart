import 'package:flutter/foundation.dart';

/// Model for a cart item.
class CartItem {
  /// The id for this cart item.
  final String id;

  /// The title for this cart item.
  final String title;

  /// The quantity for this cart item.
  final int quantity;

  /// The price for this cart item.
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}
