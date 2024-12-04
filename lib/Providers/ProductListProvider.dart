import 'package:flutter/material.dart';
import '../Models/ProductListModel.dart';
import '../Services/ApiService.dart';

class ProductListProvider with ChangeNotifier {
  List<ProductListModel>? _productList = [];
  List<ProductListModel>? get productList => _productList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentLimit = 5; // Initial limit

  Future<void> fetchProductsList() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      var response = await ApiService.getProductsList(_currentLimit);
      if (response != null && response.isNotEmpty) {
        // Append new products to the existing list
        _productList?.addAll(response);
        _currentLimit += 5; // Increment the limit for the next fetch
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

