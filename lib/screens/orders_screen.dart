import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

/// Widget for the displaying the Orders screen.
///
/// Shows a list of all [OrderItem] object in [Orders].
///
/// [routeName] to navigate to this page is '/orders
class OrdersScreen extends StatelessWidget {
  /// Route used to navigate to this page.
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Container(
          constraints: BoxConstraints(minWidth: 500, maxWidth: 500),
          child: ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
          ),
        ),
      ),
    );
  }
}
