import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Center(
              child: Column(
                children: [
                  AppBar(
                    title: Text('Shop App'),
                    automaticallyImplyLeading: false,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/usman.jpg'),
                      //child: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Muhammad Usman',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop_rounded),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment_outlined),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
