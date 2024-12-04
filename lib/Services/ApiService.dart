import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Models/ProductListModel.dart';

class ApiService {
  static String host = "https://fakestoreapi.com";

  /// Fetch Products List
  static Future<List<ProductListModel>?> getProductsList(int limit) async {
    try {
      final url = Uri.parse("$host/products?limit=$limit");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Parse the list of products
        return jsonResponse
            .map((product) => ProductListModel.fromJson(product))
            .toList();
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Catch and log any exceptions
      print("Error occurred while fetching products: $e");
      return null;
    }
  }

}
