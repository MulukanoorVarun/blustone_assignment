import 'dart:io';

import 'package:blustone_assignment/Services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../Models/ProductDetailsModel.dart'; // For ChangeNotifier

class ProductDetailsProvider with ChangeNotifier {
  ProductDetailsModel? _productData;
  bool _isLoading = false;
  ProductDetailsModel? get productData => _productData;
  bool get isLoading => _isLoading;
  Future<void> fetchProductDetails(String productId) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await ApiService.getProductDetails(productId);
      _productData = response;
    } catch (e) {
      throw Exception('Failed to fetch product details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
