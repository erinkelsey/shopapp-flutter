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
  /// [FocusNode] for price text field. Used to move between fields
  /// when pressing next on keyboard.
  final _priceFocusNode = FocusNode();

  /// [FocusNode] for description text field.
  final _descriptionFocusNode = FocusNode();

  /// [TextEditingController] for image url field. Used to show the
  /// image preview.
  final _imageUrlController = TextEditingController();

  /// [FocusNode] for the image url field. Used to get rid of focus on
  /// field, so that previews is displayed.
  final _imageUrlFocusNode = FocusNode();

  /// Unique key for the product details form.
  final _form = GlobalKey<FormState>();

  /// The current state of the form.
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );

  /// Tracks whether is in initial build of widget.
  var _isInit = true;

  /// Initial values for the form.
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  /// Tracks whether the form is submitting/loading.
  var _isLoading = false;

  /// Add listener to the image url field, so that the image preview
  /// can be shown when the field loses focus.
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  /// Initalize the form with values of an existing product. If
  /// editing a product, not adding a new one.
  ///
  /// Can't get parameter in initState, therefore need to use
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

  /// Disponse of all focus nodes, and controllers, so no memory leaks.
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

  /// Called when moved from image url field to another field.
  /// Used to show preview of image.
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  /// Called when a user hits save to submit the form.
  ///
  /// Checks that the form passes validation. Either adds a new
  /// product, or updates an existing one, depending on if there
  /// is an existing product.
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    // don't do anything more if form doesn't pass validation
    if (!isValid) return;

    _form.currentState.save();

    setState(() {
      _isLoading = true;
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
            title: Text('An error occured!'),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
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
