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

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Center(
                  child: Consumer<Products>(
                    builder: (ctx, productsData, _) => Container(
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
                  ),
                ),
              ),
      ),
    );
  }
}
