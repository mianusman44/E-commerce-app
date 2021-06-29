// ignore: unused_import
import 'package:e_commerce_app/providers/auth.dart';
import 'package:e_commerce_app/screens/splash_screen.dart';

// ignore: unused_import
import './widgets/bottom_navybar.dart';

import './screens/cart_screen.dart';

import './providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            //if version 3.0.0 then builder if version 4 or greater then create
            // ignore: deprecated_member_use
            create: (ctx) => Auth(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Products>(
            //if version 3.0.0 then builder if version 4 or greater then create
            // ignore: deprecated_member_use
            update: (ctx, authData, previousProducts) => Products(
                authData.token,
                authData.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            //if version 3.0.0 then builder if version 4 or greater then create
            // ignore: deprecated_member_use
            create: (ctx) => Cart(),
          ),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Orders>(
            //if version 3.0.0 then builder if version 4 or greater then create
            // ignore: deprecated_member_use
            update: (ctx, authObject, previousOrderObject) => Orders(
                authObject.token,
                authObject.userId,
                previousOrderObject == null ? [] : previousOrderObject.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: authData.isAuth
                  ? NavyBar()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              //NavyBar(),
              //initialRoute: '/',
              routes: {
                ProductsOverviewScreen.routeName: (ctx) =>
                    ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
