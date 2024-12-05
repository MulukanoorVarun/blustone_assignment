import 'package:flutter/material.dart';
import '../Models/ProductListModel.dart';
import '../Services/ApiService.dart';

class ProductListProvider with ChangeNotifier {
  List<ProductListModel>? _productList = [];
  List<ProductListModel>? get productList => _productList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentLimit = 6;

  Future<void> fetchProductsList() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      var response = await ApiService.getProductsList(_currentLimit);
      if (response != null && response.isNotEmpty) {
        var existingIds =
            _productList?.map((product) => product.id).toSet() ?? {};
        var newProducts = response
            .where((product) => !existingIds.contains(product.id))
            .toList();
        if (newProducts.isNotEmpty) {
          _productList?.addAll(newProducts);
          _currentLimit += 6;
        } else {
          print('No new products to add.');
        }
      } else {
        print('No more products available.');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
