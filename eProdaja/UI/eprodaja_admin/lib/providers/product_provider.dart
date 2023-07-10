import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  static String? _baseUrl;

  ProductProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "")
  }
}
