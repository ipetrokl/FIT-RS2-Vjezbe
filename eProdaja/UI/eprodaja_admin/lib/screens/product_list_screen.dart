import 'package:eprodaja_admin/screens/product_detail_screen.dart';
import 'package:eprodaja_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
      child: Column(
        children: [
          Text("Test"),
          SizedBox(
            height: 8, 
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductDetailScreen(),
                      ),
                    );
              },
              child: Text("Login"))
        ],
      ),
    ),
    title: "Product list",
    );
  }
}
