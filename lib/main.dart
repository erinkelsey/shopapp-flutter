import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() {
  const api = String.fromEnvironment('FIREBASE_API_KEY');
  print(api);
  runApp(MyApp());
}

/// Main entry point for app
///
/// Manages the providers needed for state management
/// of the app.
///
/// Manages the routes to the screens in the app.
///
/// Manages the app theme.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // best to use create when potential for adding new
          // instanses of objects
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: MaterialApp(
          title: 'ChicShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.pink[100],
              fontFamily: 'Lato'),
          // home: ProductOverviewScreen(),
          home: AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          }),
    );
  }
}
