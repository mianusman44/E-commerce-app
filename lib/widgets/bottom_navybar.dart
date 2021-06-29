import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import '../screens/products_overview_screen.dart';
import '../screens/cart_screen.dart';
// ignore: unused_import
import '../widgets/badge.dart';
// ignore: unused_import
import '../widgets/app_drawer.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
// ignore: unused_import
import '../providers/cart.dart';

class NavyBar extends StatefulWidget {
  static const routeName = '/navy-bar';
  @override
  _NavyBarState createState() => _NavyBarState();
}

class _NavyBarState extends State<NavyBar> {
  // ignore: unused_field
  var _showOnlyfavorites = false;
  // ignore: unused_field
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': ProductsOverviewScreen(),
        'title': 'Products Screen',
      },
      {
        'page': CartScreen(),
        'title': 'Cart Screen',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //drawer: AppDrawer(),
      body: _selectedPageIndex == 0 ? ProductsOverviewScreen() : CartScreen(),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Theme.of(context).primaryColor,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: _selectedPageIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: _selectPage,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            title: Text('Cart'),
            activeColor: Colors.white,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
