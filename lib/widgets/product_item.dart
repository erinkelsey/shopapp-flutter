import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

/// Widget for displaying product details in a [GridTile].
///
/// Shows a [SnackBar] when product is added to [Cart].
///
/// Toggle marking this product as a favorite.
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// The [Product] to dispaly details of.
    final product = Provider.of<Product>(context, listen: false);

    /// The [Cart] that the product can be added to.
    final cart = Provider.of<Cart>(context, listen: false);

    /// The authenticatio data for this user.
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          // only rebuilds the icon button, if the state
          // changes -> more efficient
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () =>
                  product.toggleFavoriteStatus(authData.token, authData.userId),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                // hide snackbar, if already being shown
                Scaffold.of(context).hideCurrentSnackBar();
                // reach out to nearest Scaffold
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                      // textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cart.removeSingleItem(product.id),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
