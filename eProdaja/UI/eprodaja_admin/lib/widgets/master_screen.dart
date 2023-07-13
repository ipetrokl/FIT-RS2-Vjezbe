import 'package:eprodaja_admin/main.dart';
import 'package:eprodaja_admin/screens/product_list_screen.dart';
import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';

// ignore: must_be_immutable
class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreenWidget({this.child, this.title, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("back"),
              onTap: () {
                Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
              },
            ),
            ListTile(
              title: Text("Proizvodi"),
              onTap: (){
                 Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProductListScreen(),
                      ),
                    );
              },
            ),
            ListTile(
              title: Text("Detalji"),
              onTap: (){
                 Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(),
                      ),
                    );
              },
            )
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
