import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

/// Widget for building the screen that displays all of the user's products.
///
/// [routeName] to navigate to this screen is '/user-products'
class UserProductsScreen extends StatelessWidget {
  /// Route used to navigate to this screen.
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(maxWidth: 500, minWidth: 500),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  UserProductItem(
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl,
                  ),
                  // Divider(),
                ],
              ),
            ),
          ),
        ));
  }
}
