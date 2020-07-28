import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

/// Widget for the screen where user's can edit and add
/// [Product] items.
///
/// [routeName] to navigate to this page is '/edit-product'
class EditProductScreen extends StatefulWidget {
  /// Route used to navigate to this page.
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  /// Cant get parameter in initState, therefore need to use
  /// this method instead.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    // when working with focus nodes, must manually dispose of them
    // as they can become memory leaks
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();

    // don't do anything more if form doesn't pass validation
    if (!isValid) return;

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
          Navigator.of(context).pop();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                alignment: Alignment.topCenter,
                constraints: BoxConstraints(minWidth: 500, maxWidth: 500),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              // Error text
                              return 'Please enter a title.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // better option to have mutable product class
                            _editedProduct = Product(
                              title: value,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              // Error text
                              return 'Please enter a price.';
                            }
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0)
                              return 'Please enter a valid price.';
                            return null;
                          },
                          onSaved: (value) {
                            // better option to have mutable product class
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(value),
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Please enter a description.';
                            if (value.length < 10)
                              return 'Description must be at least 10 characters.';
                            return null;
                          },
                          onSaved: (value) {
                            // better option to have mutable product class
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: value,
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                top: 15,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                // want access to value before it is submitted
                                // therefore, need a controller
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) => _saveForm(),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please enter an image.';
                                  if (!value.startsWith('https') &&
                                      !value.startsWith('http'))
                                    return 'Please enter a valid URL.';
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg'))
                                    return 'Please enter a valid image URL.';
                                  return null;
                                },
                                onSaved: (value) {
                                  // better option to have mutable product class
                                  _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description,
                                    id: _editedProduct.id,
                                    imageUrl: value,
                                    isFavorite: _editedProduct.isFavorite,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
