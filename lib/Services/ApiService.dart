import 'dart:convert';

import 'package:blustone_assignment/Models/ProductDetailsModel.dart';
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

  static Future<ProductDetailsModel?> getProductDetails(String? product_id) async {
    try {
      final url = Uri.parse("$host/products/$product_id");
      final response = await http.get(
        url
      );
      // Check the response status code
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("getProductDetails response: ${response.body}");

        // Parse the JSON response into a model
        return ProductDetailsModel.fromJson(jsonResponse);
      } else {
        // Handle non-200 responses (e.g., 401, 404, etc.)
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Catch any exceptions (e.g., network failure, JSON parsing error)
      print("Error occurred: $e");
      return null;
    }
  }

}
