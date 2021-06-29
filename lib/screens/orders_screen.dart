import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'Order-screen';

  @override
  Widget build(BuildContext context) {
    print('Building orders ones');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders Screen'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndGetOrder(),
        // ignore: missing_return
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occor'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
