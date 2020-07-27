import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/product.dart';
import '../widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Pants',
      description: 'A nice pair of pants.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    final bool isLandscapeWeb =  
        kIsWeb && MediaQuery.of(context).orientation 
          == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trés Chic Shop'),
      ),
      body: Container(
        margin: isLandscapeWeb
          ? EdgeInsets.all(20) 
          : null,
        child: GridView.builder( 
          padding: const EdgeInsets.all(10.0),
          itemCount: loadedProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( 
            crossAxisCount: 2,
            childAspectRatio: 3 /2,
            crossAxisSpacing: isLandscapeWeb 
              ? 20 
              : 10,
            mainAxisSpacing: isLandscapeWeb 
              ? 20 
              : 10,
          ),
          itemBuilder: (ctx, index) => ProductItem( 
            id: loadedProducts[index].id,
            title: loadedProducts[index].title,
            imageUrl: loadedProducts[index].imageUrl,
          ),
        ),
      ),
    );
  }
}