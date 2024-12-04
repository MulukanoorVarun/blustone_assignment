import 'package:blustone_assignment/ProductDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/ProductListProvider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    GetProductList();
    super.initState();
  }

  Future<void> GetProductList() async {
    final products_list_provider =
    Provider.of<ProductListProvider>(context, listen: false);
    products_list_provider.fetchProductsList();
  }


  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductListProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 4; // Responsive grid layout

    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!productProvider.isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            productProvider.fetchProductsList(); // Fetch more products on scroll
            return true;
          }
          return false;
        },
        child: productProvider.isLoading && productProvider.productList!.isEmpty
            ? const Center(
          child: CircularProgressIndicator(), // Initial loader
        )
            : productProvider.productList!.isEmpty && !productProvider.isLoading
            ? const Center(
          child: Text(
            'No products available.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Dynamic columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // Adjust card aspect ratio
          ),
          padding: const EdgeInsets.all(10),
          itemCount: productProvider.productList!.length + (productProvider.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the bottom
            if (index == productProvider.productList!.length &&
                productProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = productProvider.productList![index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Productdetailsscreen(ProductId: product.id.toString()??""),
                ),
              ),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Image
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.network(
                          product.image??"",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                    // Product Title
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.title??"",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Product Price
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${product.price.toString()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    // Product Rating
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 5),
                          Text('${product.rating?.rate.toString()}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
