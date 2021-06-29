import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _chartItems = {};

  Map<String, CartItem> get chartItems {
    return {..._chartItems};
  }

  int getCartCount() {
    return _chartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _chartItems.forEach((key, cartitem) {
      total += cartitem.price * cartitem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_chartItems.containsKey(productId)) {
      //update cart quantity
      _chartItems.update(
          productId,
          (existingproduct) => CartItem(
              id: existingproduct.id,
              title: existingproduct.title,
              quantity: existingproduct.quantity + 1,
              price: existingproduct.price));
    } else {
      _chartItems.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removecartItem(String productId) {
    _chartItems.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_chartItems.containsKey(productId)) {
      return;
    }
    if (_chartItems[productId].quantity > 1) {
      _chartItems.update(
          productId,
          (existingcartdata) => CartItem(
              id: existingcartdata.id,
              title: existingcartdata.title,
              quantity: existingcartdata.quantity - 1,
              price: existingcartdata.price));
    } else {
      _chartItems.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _chartItems = {};
    notifyListeners();
  }
}
