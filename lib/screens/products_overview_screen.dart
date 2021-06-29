import '../widgets/app_drawer.dart';

import './cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_Grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = 'overview-screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyfavorites = false;
  var _isInit = true;
  // ignore: unused_field
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndGetProduct();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndGetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyfavorites = true;
                  } else {
                    _showOnlyfavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Favorites')
                        ],
                      ),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.all_inbox_rounded,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('All Products')
                        ],
                      ),
                      value: FilterOptions.All,
                    )
                  ]),
          Consumer<Cart>(
            builder: (ctx, cartdata, chld) => Badge(
              child: chld,
              value: cartdata.getCartCount().toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_rounded),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyfavorites),
    );
  }
}
