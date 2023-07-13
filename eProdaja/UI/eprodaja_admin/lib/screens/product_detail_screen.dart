import 'package:eprodaja_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  Product? product;
  ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Text("Details"),
      title: this.widget.product?.naziv ?? "Details",
    );
  }
}
