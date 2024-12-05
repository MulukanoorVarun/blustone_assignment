import 'dart:io';

import 'package:blustone_assignment/Services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../Models/ProductDetailsModel.dart';  // For ChangeNotifier


class ProductDetailsProvider with ChangeNotifier {
  ProductDetailsModel? _productData;
  bool? _isInWishlist;
  bool _isLoading = false;

  // Getters
  ProductDetailsModel? get productData => _productData;
  bool? get isInWishlist => _isInWishlist;
  bool get isLoading => _isLoading;

  // Fetch product details from the repository using the productId
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

  // Toggle wishlist status (to be called when user interacts with the UI)
  void toggleWishlistStatus() {
    if (_productData == null) return;
    bool newStatus = !(isInWishlist ?? false);  // Toggle wishlist status
    print("NEW STATUS:${newStatus}");
    // Update local state
    _isInWishlist = newStatus;
    notifyListeners();
  }
}


