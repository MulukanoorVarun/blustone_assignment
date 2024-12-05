import 'package:blustone_assignment/ProductDetailsScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'Providers/ConnectivityService.dart';
import 'Providers/ProductListProvider.dart';
import 'Utils/MyWidgets.dart';
import 'Utils/Shimmers.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    GetProductList();
    Provider.of<ConnectivityService>(context, listen: false).initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityService>(context, listen: false).dispose();
    super.dispose();
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
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final crossAxisCount = screenWidth < 600 ? 2 : 4;

    final spinkits = Spinkits3();

    final _connectivityService = Provider.of<ConnectivityService>(context);
    return (_connectivityService.isDeviceConnected ==
                "ConnectivityResult.wifi" ||
            _connectivityService.isDeviceConnected ==
                "ConnectivityResult.mobile")
        ? Scaffold(
            appBar: CustomApp(title: 'Products List', w: screenWidth),
            body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!productProvider.isLoading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    productProvider
                        .fetchProductsList(); // Fetch more products on scroll
                    return true;
                  }
                  return false;
                },
                child: productProvider.isLoading &&
                        productProvider.productList!.isEmpty
                    ? _buildShimmerGrid()
                    : productProvider.productList!.isEmpty &&
                            !productProvider.isLoading
                        ? const Center(
                            child: Text(
                              'No products available.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomScrollView(
                              slivers: [
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        crossAxisCount, // Dynamic columns
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio:
                                        0.58, // Adjust card aspect ratio
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final product =
                                          productProvider.productList![index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) {
                                              return ProductDetailsScreen(
                                                  productId:
                                                  product.id.toString() ??
                                                      "");
                                            },
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.easeInOut;
                                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                              var offsetAnimation = animation.drive(tween);
                                              return SlideTransition(position: offsetAnimation, child: child);
                                            },
                                          ));
                                        },
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // Product Image
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(10),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(8),
                                                              topLeft: Radius
                                                                  .circular(8)),
                                                      color: Colors.grey
                                                          .shade200, // Set background color
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          product.image ?? "",
                                                      height: h * 0.22,
                                                      width: w * 0.8,
                                                      fit: BoxFit.contain,
                                                      placeholder:
                                                          (BuildContext context,
                                                              String url) {
                                                        return Center(
                                                          child: spinkits
                                                              .getSpinningLinespinkit(),
                                                        );
                                                      },
                                                      errorWidget:
                                                          (BuildContext context,
                                                              String url,
                                                              dynamic error) {
                                                        // Handle error in case the image fails to load
                                                        return Icon(
                                                            Icons.error);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  product.title ?? "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    height: 1.2,
                                                    fontFamily: 'RozhaOne',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              // Product Rating
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  children: [
                                                    if (product.rating?.rate !=
                                                            null &&
                                                        product.rating!.rate !=
                                                            0.0) ...[
                                                      Row(
                                                        children: List.generate(
                                                            5, (starIndex) {
                                                          double ratingValue =
                                                              product.rating!
                                                                      .rate ??
                                                                  0.0;
                                                          if (starIndex <
                                                              ratingValue
                                                                  .floor()) {
                                                            // Full star
                                                            return Icon(
                                                                Icons.star,
                                                                color: Color(
                                                                    0xffF79009),
                                                                size: 14);
                                                          } else if (starIndex <
                                                                  ratingValue &&
                                                              starIndex <
                                                                  ratingValue
                                                                      .ceil()) {
                                                            // Half star
                                                            return Icon(
                                                                Icons.star_half,
                                                                color: Color(
                                                                    0xffF79009),
                                                                size: 14);
                                                          } else {
                                                            // Empty star
                                                            return Icon(Icons.star_border,
                                                                color: Color(
                                                                    0xffF79009),
                                                                size: 14);
                                                          }
                                                        }),
                                                      ),
                                                      Text(
                                                        ' (${product.rating!.count})',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'RozhaOne',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  '₹ ${product.price.toString()}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    height: 1,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'RozhaOne',
                                                    color: Color(0xff4B5565),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    childCount:
                                        productProvider.productList!.length,
                                  ),
                                ),
                                // Loader at the bottom of the list
                                if (productProvider.isLoading)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )),
          )
        : NoInternetWidget();
  }

  Widget _buildShimmerGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // Dynamic columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.58,
        ),
        itemCount: 6,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Shimmer for Product Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: shimmerRectangle(screenWidth,150),
                  ),
                ),
                const SizedBox(height: 6),
                // Shimmer for Product Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: shimmerRectangle(120,10),
                ),
                const SizedBox(height: 6),
                // Shimmer for Product Rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: shimmerRectangle(80,10),
                ),
                const SizedBox(height: 6),
                // Shimmer for Product Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: shimmerRectangle(60,10),
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
