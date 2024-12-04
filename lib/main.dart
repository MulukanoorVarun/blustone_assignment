import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:blustone_assignment/productlistScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Providers/ConnectivityService.dart';
import 'Providers/ProductListProvider.dart';







Future<void> main() async {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductListProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BlueStone Project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          cardColor: Colors.white,
          searchBarTheme: const SearchBarThemeData(),
          tabBarTheme: const TabBarTheme(),
          dialogTheme: const DialogTheme(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // Set the border radius of the dialog
            ),
          ),
          buttonTheme: const ButtonThemeData(),
          popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white, shadowColor: Colors.white),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.white,
          ),
          cardTheme: const CardTheme(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            color: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
            ),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Colors.white, backgroundColor: Colors.white),
          colorScheme: const ColorScheme.light(background: Colors.white)
              .copyWith(background: Colors.white),
        ),
        home:ProductListScreen()
    );
  }
}