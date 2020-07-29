import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';

/// Provider class for the cart
///
/// Cart holds the current items in the cart.
///
/// Provides methods to:
/// - Get all items in cart.
/// - Get number of items in cart.
/// - Get total amount of all items in the cart.
/// - Add an item to the cart.
/// - Increase quantity of an existing cart item.
/// - Remove an item to the cart.
/// - Clear all items out of the cart.
class Cart with ChangeNotifier {
  /// The items in the cart.
  Map<String, CartItem> _items = {};

  /// Returns the items in the cart.
  Map<String, CartItem> get items {
    return {..._items};
  }

  /// Returns the number of items in the cart.
  int get itemCount {
    return _items.length;
  }

  /// Returns the total of all the items in the cart.
  /// If there an item has a quantity of > 1, the total
  /// of that item is the price * quantity
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  /// Add an item to the cart, if [productId] is not in the cart already
  /// If [productId] is in the cart, increase the [CartItem.quantity] of
  /// the item that has the matching [productId]
  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  /// Remove item from cart with key of [productId].
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  /// Removes [CartItem] from [Cart] for [productId]
  ///
  /// If quantity of [CartItem] with [productId] is greater
  /// than 1, reduce the quantity, else remove the item
  /// from [Cart] entirely.
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  /// Clear cart by setting it back to an empty map.
  void clear() {
    _items = {};
    notifyListeners();
  }
}
