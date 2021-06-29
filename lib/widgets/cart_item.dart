import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning_rounded),
                SizedBox(
                  width: 10,
                ),
                Text('Are you Sure ?')
              ],
            ),
            content: Text('Do you Want to remove the item from the cart ?'),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('Yes')),
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No')),
            ],
          ),
        );
        // return Future.value(true);
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removecartItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              // ignore: unnecessary_brace_in_string_interps
              child: Padding(
                padding: const EdgeInsets.all(5),
                // ignore: unnecessary_brace_in_string_interps
                child: FittedBox(child: Text('\$${price}')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ${(quantity * price)}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
