import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'User-Products-Screen';

  Future<void> _fetchRefreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndGetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _fetchRefreshProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await _fetchRefreshProducts(context);
                    },
                    child: Consumer<Products>(
                      builder: (ctx, productData, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (ctx, i) => UserProductItem(
                              productData.items[i].id,
                              productData.items[i].title,
                              productData.items[i].imageUrl),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
