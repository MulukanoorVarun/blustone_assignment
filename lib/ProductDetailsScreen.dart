import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shimmer/shimmer.dart';

import 'Providers/ConnectivityService.dart';
import 'Providers/ProductDetailsProvider.dart';
import 'Utils/MyWidgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  String productId;
  ProductDetailsScreen(
      {super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final spinkits = Spinkits3();
  bool _isDescriptionVisible = true;
  void _toggleDescriptionVisibility() {
    setState(() {
      _isDescriptionVisible = !_isDescriptionVisible;
    });
  }
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityService>(context, listen: false).initConnectivity();
    GetProductDetails();
  }

  @override
  void dispose() {
    Provider.of<ConnectivityService>(context, listen: false).dispose();
    super.dispose();
  }


  Future<void> GetProductDetails() async {
    final ProductdetailsProvider =
    Provider.of<ProductDetailsProvider>(context, listen: false);
    ProductdetailsProvider.fetchProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final _connectivityService = Provider.of<ConnectivityService>(context);
    return (_connectivityService.isDeviceConnected == "ConnectivityResult.wifi" ||
        _connectivityService.isDeviceConnected == "ConnectivityResult.mobile")
        ?
    Scaffold(
      appBar: CustomApp(title: 'Product Details', w: w),
      body: Consumer<ProductDetailsProvider>(
          builder: (context, productDetailsProvider, child) {
            final productData = productDetailsProvider.productData;
            print("Image:${productData?.image}");
            if (productDetailsProvider.isLoading) {
              return _buildShimmerProductDetails();
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        InkResponse(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return PhotoViewScreen(imageUrl: productData?.image??"");
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
                          child: Container(
                            height: h * 0.3,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            decoration:
                            BoxDecoration(color: Color(0xffEDF4FB)),
                            child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: productData?.image ?? "",
                                  height: h * 0.25,
                                  width: w * 0.8,
                                  fit: BoxFit.contain,
                                  placeholder:
                                      (BuildContext context, String url) {
                                    return Center(
                                      child: spinkits.getSpinningLinespinkit(),
                                    );
                                  },
                                  errorWidget: (BuildContext context, String url,
                                      dynamic error) {
                                    // Handle error in case the image fails to load
                                    return Icon(Icons.error);
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.01),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Color(0xffFCFCFD)),
                      child: Column(
                        children: [
                          Container(
                            width: w,
                            child: Text(
                              productData?.title ?? "",
                              style: TextStyle(
                                color: Color(0xff110B0F),
                                fontFamily: 'RozhaOne',
                                fontSize: 22,
                                height: 32 / 24,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "₹${productData?.price}",
                                style: TextStyle(
                                  color: Color(0xff4B5565),
                                  fontFamily: 'RozhaOne',
                                  fontSize: 24,
                                  height: 28 / 24,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (productData?.rating?.rate != null && productData?.rating!.rate != 0.0) ...[
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    double ratingValue = productData?.rating!.rate ?? 0.0;
                                    if (starIndex < ratingValue.floor()) {
                                      // Full star
                                      return Icon(Icons.star, color: Color(0xffF79009), size: 14);
                                    } else if (starIndex < ratingValue && starIndex < ratingValue.ceil()) {
                                      // Half star
                                      return Icon(Icons.star_half, color: Color(0xffF79009), size: 14);
                                    } else {
                                      // Empty star
                                      return Icon(Icons.star_border, color: Color(0xffF79009), size: 14);
                                    }
                                  }),
                                ),
                                Text(' (${productData?.rating!.count})',style: TextStyle(
                                    fontFamily: 'RozhaOne',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300
                                ),),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Color(0xffEEF2F6),
                          ),
                          SizedBox(height: h * 0.01),
                          Row(
                            children: [
                              Text(
                                "DESCRIPTION",
                                style: TextStyle(
                                  color: Color(0xff121926),
                                  fontFamily: 'RozhaOne',
                                  fontSize: 14,
                                  height: 19.36 / 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: _toggleDescriptionVisibility,
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xff9AA4B2),
                                      borderRadius:
                                      BorderRadius.circular(100),
                                    ),
                                    child: Icon(
                                      _isDescriptionVisible
                                          ? Icons.keyboard_arrow_up_sharp
                                          : Icons.keyboard_arrow_down_sharp,
                                      color: Colors.white,
                                      size: 20,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.01),
                          if (_isDescriptionVisible)
                            Text(
                              productData?.description ?? "",
                              style: TextStyle(
                                color: Color(0xff4B5565),
                                fontFamily: 'RozhaOne',
                                fontSize: 14,
                                height: 19.36 / 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          SizedBox(height: h * 0.01),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          ),
    ):
    NoInternetWidget();
  }

  Widget _buildShimmerProductDetails() {
    final screenWidth = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: h * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(color: Color(0xffEDF4FB)),
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: h * 0.25,
                      width: screenWidth * 0.8,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Color(0xffFCFCFD)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shimmer for Title
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: screenWidth * 0.6,
                    height: 20,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: 10),
                // Shimmer for Price
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: screenWidth * 0.3,
                    height: 24,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: 10),
                // Shimmer for Rating
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: screenWidth * 0.5,
                    height: 14,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Color(0xffEEF2F6),
                ),
                SizedBox(height: h * 0.01),
                // Shimmer for Description Title
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: screenWidth * 0.4,
                    height: 14,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: h * 0.01),
                // Shimmer for Description Text
                Column(
                  children: List.generate(
                    3,
                        (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: screenWidth,
                          height: 14,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
