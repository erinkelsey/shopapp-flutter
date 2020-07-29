import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-flutter-e7a32.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
