// ignore: unused_import

import 'dart:convert';

import './cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndGetOrder() async {
    final url =
        'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await https.get(Uri.parse(url));
    print(json.decode(response.body));

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId.toString(),
        amount: orderData['amount'].toDouble(),
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>).map((item) {
          return CartItem(
              id: item['id'].toString(),
              title: item['title'].toString(),
              quantity: item['quantity'].toDouble(),
              price: item['price'].toDouble());
        }).toList(),
      ));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await https.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: DateTime.now(),
        ));

    notifyListeners();
  }
}
