import 'package:flutter/material.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _discountFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  // ignore: unused_field
  var _editedProduct = Product(
      id: null,
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
      discount: 0);

  var _isInit = true;
  var isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'discount': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_imageUpdate);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);

        _editedProduct = product;

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'discount': _editedProduct.discount.toString(),
          'imageUrl': '',
          // 'imageUrl': _editedProduct.imageUrl,
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _imageUpdate() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpej')) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _discountFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_imageUpdate);
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error occured!'),
                  content: Text('Something went wrong!'),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                      child: Text('okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }

      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter title it is a required field';
                          }
                          return null;
                        },
                        onSaved: (enteredValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: enteredValue,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            discount: _editedProduct.discount,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_discountFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter a Valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please Enter a number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (enteredValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(enteredValue),
                            imageUrl: _editedProduct.imageUrl,
                            discount: _editedProduct.discount,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['discount'],
                        decoration: InputDecoration(
                          labelText: 'Discount',
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: _discountFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a discount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please Enter a Valid number';
                          }
                          if (double.parse(value) < 0) {
                            return 'Please Enter a number greater than minus';
                          }
                          return null;
                        },
                        onSaved: (enteredValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            discount: double.parse(enteredValue),
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a description field';
                            }
                            if (value.length < 10) {
                              return 'Should be 10 character long';
                            }
                            return null;
                          },
                          onSaved: (enteredValue) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: enteredValue,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              discount: _editedProduct.discount,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          }),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a Url')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                // initialValue: _initValues['imageUrl'],
                                decoration: InputDecoration(
                                  labelText: 'Image Url',
                                ),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a ImageUrL';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URl';
                                  }
                                  if (!value.endsWith('jpg') &&
                                      !value.endsWith('png') &&
                                      !value.endsWith('jpej')) {
                                    return 'Please enter a valid image formate e.g jpg';
                                  }
                                  return null;
                                },
                                onSaved: (enteredValue) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: enteredValue,
                                    discount: _editedProduct.discount,
                                    isFavorite: _editedProduct.isFavorite,
                                  );
                                }),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
