import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isLandscapeWeb =
        kIsWeb && MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trés Chic Shop'),
      ),
      body: Container(
        margin: isLandscapeWeb ? EdgeInsets.all(20) : null,
        child: ProductsGrid(),
      ),
    );
  }
}
