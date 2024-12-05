import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

class CustomSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.black, fontFamily: "Inter"),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFE7C6A0),
      ),
    );
  }
}

class Spinkits {
  Widget getFadingCircleSpinner({Color color = Colors.white}) {
    return SizedBox(
      height: 15,
      width: 35,
      child: SpinKitThreeBounce(
        size: 20,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color, // Use the passed color or default to white
            ),
          );
        },
      ),
    );
  }
}

class Spinkits1 {
  Widget getWavespinkit() {
    return SizedBox(
      height: 20,
      width: 55,
      child: SpinKitWave(
        color: Color(0xffE7C6A0),
      ),
    );
  }
}


class Spinkits2 {
  Widget getSpinningLinespinkit() {
    return SizedBox(
      height: 20,
      width: 55,
      child: SpinKitSpinningLines(
        color: Color(0xffE7C6A0),
      ),
    );
  }
}

class Spinkits3 {
  Widget getSpinningLinespinkit() {
    return SizedBox(
      height: 20,
      width: 55,
      child: SpinKitSpinningLines(
        color: Color(0xffE7C6A0),
      ),
    );
  }
}


class CustomApp extends StatelessWidget implements PreferredSizeWidget {
  final double w;
  final String title;

  CustomApp({required this.title, required this.w});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      actions: <Widget>[Container()],
      toolbarHeight: 50,
      backgroundColor: const Color(0xff110B0F),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            InkResponse(
              onTap: () {
                Navigator.pop(context,true);
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Color(0xffffffff)),
                  const SizedBox(width: 12),
                ],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Color(0xffffffff),
                fontFamily: 'RozhaOne',
                fontSize: 24,
                height: 32 / 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}


class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/no_internet.png",
                width: 200,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Text(
                  "Connect to the Internet",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontFamily: 'RozhaOne',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Text(
                  "You are Offline. Please Check Your Connection",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontFamily: 'RozhaOne',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final connectivityResult = await Connectivity().checkConnectivity();
                  String message;

                  if (connectivityResult == ConnectivityResult.mobile) {
                    message = "Connected to Mobile Network";
                  } else if (connectivityResult == ConnectivityResult.wifi) {
                    message = "Connected to WiFi";
                  } else {
                    message = "No Internet Connection";
                  }
                  CustomSnackBar.show(context, message);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 38),
                  child: Container(
                    width: 240,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color(0xff000000),
                    ),
                    child: const Center(
                      child: Text(
                        "Retry",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontFamily: 'RozhaOne',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PhotoViewScreen extends StatelessWidget {
  final String imageUrl;

  PhotoViewScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.white, size: 32),
              onPressed: () {
                Navigator.pop(context); // Close the PhotoViewScreen
              },
            ),
          ),
        ],
      ),
    );
  }
}