import 'package:flutter/foundation.dart';

import '../models/order_item.dart';
import '../models/cart_item.dart';

/// Provider class for the orders.
///
/// Methods:
/// - addOrder: adds a new order to list of all orders
///
class Orders with ChangeNotifier {
  /// List of OrderItems as all of the orders
  List<OrderItem> _orders = [];

  /// Returns the list of all of the orders as
  /// a list of OrderItems
  List<OrderItem> get orders {
    return [..._orders];
  }

  /// Adds a new order.
  ///
  /// Add new OrderItem to list of orders at beginning
  /// of list. Notifies any listeners of this provider.
  ///
  /// Arguments:
  /// - cartProducts (List<CartItem>): cart items to add to list
  /// - total (double): total of the order; total of all items in cart
  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
