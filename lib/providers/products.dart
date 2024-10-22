import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

/// Provider class for containing a list of [Product] items
class Products with ChangeNotifier {
  /// The authentication token for this user.
  final String authToken;

  /// The unique identifier for this user.
  final String userId;

  /// The [Product] items to return.
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Pants',
    //   description: 'A nice pair of pants.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Frying Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Products(this.authToken, this.userId, this._items);

  /// Returns a list of [Product] items.
  List<Product> get items {
    return [..._items];
  }

  /// Returns a list of [Product] items that are favorites of
  /// this user.
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  /// Find a specific [Product] item in [Products] with [id].
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /// Gets all of the products requested from the web server.
  ///
  /// If [filterByUser] is set to false (default), gets all of the products, else
  /// only gets this user's products.
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    const dbUrl = String.fromEnvironment('FIREBASE_DB_URL');

    final url = '${dbUrl}products.json?auth=$authToken$filterString';

    final favoriteUrl = '${dbUrl}userFavorites/$userId.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favoriteData == null
                ? false
                : (favoriteData[prodId] == null
                    ? false
                    : favoriteData[prodId]['isFavorite'] ?? false),
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// Sends [product] to the server to create a new [Product].
  ///
  /// [Product] is linked to this user, as the creator of the product.
  Future<void> addProduct(Product product) async {
    const dbUrl = String.fromEnvironment('FIREBASE_DB_URL');

    final url = '${dbUrl}products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /// Updates a [Product] on the server with [id], by setting it to [newProduct].
  ///
  /// Only this user can update this user's products. This user cannot update
  /// products created by another user.
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      const dbUrl = String.fromEnvironment('FIREBASE_DB_URL');
      final url = '${dbUrl}products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  // optimistic updating
  // removes product from local cache, but keeps a pointer to it
  // in memory,  and adds it back, if there is an deleting on the server
  // if no issue, set point to null to allow removal from memory

  /// Deletes a [Product] from server with [id].
  Future<void> deleteProduct(String id) async {
    const dbUrl = String.fromEnvironment('FIREBASE_DB_URL');
    final url = '${dbUrl}products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
  }
}
