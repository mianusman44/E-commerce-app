import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;
  // final double discount;

  // ProductItem(this.id, this.title, this.imageUrl, this.price, this.discount);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
            ),
          ),
          title: Text(''),

          trailing: product.discount > 0
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 50,
                    width: 60,
                    alignment: Alignment.center,
                    color: Colors.black54,
                    child: Text(
                      '${product.discount.ceil().toString()}\% Off',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Text(''),

          //backgroundColor: Colors.black12,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Text(
            // ignore: unnecessary_brace_in_string_interps
            '${product.title}',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          title: Text(
            // ignore: unnecessary_brace_in_string_interps
            '\$ ${product.price - (product.discount / 100 * product.price).floor()}',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.end,
          ),
          trailing: IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              // ignore: deprecated_member_use
              Scaffold.of(context).hideCurrentSnackBar();
              // ignore: deprecated_member_use
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
