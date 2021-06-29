import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart Data'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Spacer(),
                  Chip(
                    // ignore: deprecated_member_use
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              // ignore: deprecated_member_use
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // ignore: deprecated_member_use
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) {
              print(cart.chartItems.values.toList()[i].title);
              return CartItem(
                  cart.chartItems.values.toList()[i].id,
                  cart.chartItems.keys.toList()[i],
                  cart.chartItems.values.toList()[i].price,
                  cart.chartItems.values.toList()[i].quantity,
                  cart.chartItems.values.toList()[i].title);
            },
            itemCount: cart.chartItems.length,
          )),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  // ignore: unused_field
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.chartItems.values.toList(),
                  widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });

              widget.cart.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
