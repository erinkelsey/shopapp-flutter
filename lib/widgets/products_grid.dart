import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isLandscapeWeb =
        kIsWeb && MediaQuery.of(context).orientation == Orientation.landscape;

    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(
        id: products[i].id,
        title: products[i].title,
        imageUrl: products[i].imageUrl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: isLandscapeWeb ? 20 : 10,
        mainAxisSpacing: isLandscapeWeb ? 20 : 10,
      ),
    );
  }
}
