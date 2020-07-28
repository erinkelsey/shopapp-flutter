import 'package:flutter/foundation.dart';

import './cart_item.dart';

/// Model for a order item
class OrderItem {
  /// The id for this order item.
  final String id;

  /// The amount for this order item.
  final double amount;

  /// The products for this order item.
  final List<CartItem> products;

  /// The timestamp for this order item.
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
