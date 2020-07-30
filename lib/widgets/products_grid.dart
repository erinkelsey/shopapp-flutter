import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../providers/products.dart';
import './product_item.dart';

/// Widget for building the grid view of [Product] items
/// for the [ProductOverviewScreen].
///
/// Ability to filter for all of the [Product] items, or only the
/// user's favorites.
class ProductsGrid extends StatelessWidget {
  /// Boolean for displaying either all product items, or only
  /// the user's favorites.
  final bool showFavorites;

  ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final bool isLandscapeWeb =
        kIsWeb && MediaQuery.of(context).orientation == Orientation.landscape;

    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // provider tied to data -> for single list
        // grid items, flutter can recycle items
        // recommended over create
        value: products[i],
        // create: (ctx) => products[i],
        child: ProductItem(),
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
