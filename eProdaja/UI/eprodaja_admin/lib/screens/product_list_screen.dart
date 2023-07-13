

import 'package:eprodaja_admin/models/search_result.dart';
import 'package:eprodaja_admin/providers/product_provider.dart';
import 'package:eprodaja_admin/screens/product_detail_screen.dart';
import 'package:eprodaja_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../utils/util.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider _productProvider;
  SearchResult<Product>? result;

  TextEditingController _ftsController = new TextEditingController();
  TextEditingController _sifraController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _productProvider = context.read<ProductProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Product list",
      child: Container(
        child: Column(children: [
          _buildSearch(),
          _buildDataListView()
        ]),
      ),
    );
  }

  Row _buildSearch() {
    return Row(
          children: [
             Expanded(
              child: TextField(
                  decoration: const InputDecoration(
                      labelText: "Naziv ili sifra"),
                      controller: _ftsController,
                ),
            ),
            const SizedBox(
              width: 20,
            ),
             Expanded(
              child: TextField(
                  decoration: const InputDecoration(
                      labelText: "Sifra"),
                      controller: _sifraController,
                ),
            ),
            ElevatedButton(
                onPressed: () async {
                  var data = await _productProvider.get(filter: {
                    'fts': _ftsController.text,
                    'sifra': _sifraController.text
                  });

                  setState(() {
                    result = data;
                  });
                  // print("data: ${data.result[0].proizvodId}");
                },
                child: const Text("Pretraga")),
          ],
        );
  }

  Widget _buildDataListView() {
    return Expanded(child: SingleChildScrollView(child: DataTable(columns: const [
          DataColumn(
            label: Expanded(
              child: Text(
                'ID',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Sifra',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Naziv',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Cijena',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Slika',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        ], rows: result?.result.map((Product e) => DataRow( onSelectChanged: (selected) => {
          if(selected == true) {
            Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: e),
                        ),
                      )
          } 
        }
          ,cells: [
          DataCell(Text(e.proizvodId?.toString() ?? "")),
          DataCell(Text(e.sifra ?? "")),
          DataCell(Text(e.naziv ?? "")),
          DataCell(Text(formatNumber(e.cijena))),
          DataCell(e.slika != "" ? Container(width: 100, height: 100, child: imageFromBase64String(e.slika!)): Text(""))
        ])).toList() ?? []
        ),
        )
        );
  }
}
