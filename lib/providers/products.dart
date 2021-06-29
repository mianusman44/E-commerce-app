import 'package:e_commerce_app/models/http_exeption.dart';
import 'package:flutter/cupertino.dart';
// ignore: unused_import
import 'dart:convert';
import './product.dart';
// ignore: unused_import
import 'package:http/http.dart' as https;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   discount: 0,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   discount: 30,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   discount: 20.0,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   discount: 10.0,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;

  String authToken;
  String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return ([..._items]);
  }

  List<Product> get favoriteItems {
    return items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }
  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndGetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    print(userId);
    var url =
        'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    // ignore: unused_local_variable
    //final response = await https.get(Uri.parse(url));
    try {
      final response = await https.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      //final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }

      url =
          'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await https.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'].toString(),
          description: prodData['description'].toString(),
          price: prodData['price'].toDouble(),
          imageUrl: prodData['imageUrl'].toString(),
          discount: prodData['discount'].toDouble(),
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });

      _items = loadedProducts;
      notifyListeners();

      //print(json.decode(response.body));
    } catch (error) {
      // print('data from firebase not');
      throw error;
      //print(json.decode(response.body));
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await https.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'discount': product.discount,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            // 'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          discount: product.discount,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    }
    // print(json.decode(response.body));
    catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product productNew) async {
    final productIndex = _items.indexWhere((pro) => pro.id == id);
    print(_items.length);
    print(productIndex);
    print(productNew.title);
    if (productIndex >= 0) {
      final url =
          'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

      await https.patch(Uri.parse(url),
          body: json.encode({
            'title': productNew.title,
            'description': productNew.description,
            'price': productNew.price,
            'discount': productNew.discount,
            'imageUrl': productNew.imageUrl,
            // 'isFavorite': productNew.isFavorite,
          }));

      _items[productIndex] = productNew;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://ecommerce-app-907d4-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';

    final existingProductIndex =
        _items.indexWhere((prodId) => prodId.id == productId);

    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await https.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      print(response.statusCode);
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpExeption('Could not delete the product');
    }

    existingProduct = null;

    // _items.removeWhere((recent) => recent.id == productId);
    //notifyListeners();
  }
}
