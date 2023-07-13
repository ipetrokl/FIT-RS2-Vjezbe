import 'package:eprodaja_admin/models/jedinice_mjere.dart';
import 'package:eprodaja_admin/models/search_result.dart';
import 'package:eprodaja_admin/models/vrste_proizvoda.dart';
import 'package:eprodaja_admin/providers/jedinice_mjere.dart';
import 'package:eprodaja_admin/providers/vrste_proizvoda.dart';
import 'package:eprodaja_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  Product? product;
  ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late JediniceMjereProvider _jediniceMjereProvider;
  late VrsteProizvodaProvider _vrsteProizvodaProvider;
  late ProductProvider _productProvider;

  SearchResult<JediniceMjere>? jediniceMjereResult;
  SearchResult<VrsteProizvoda>? vrsteProizvodaResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'sifra': widget.product?.sifra,
      'naziv': widget.product?.naziv,
      'cijena': widget.product?.cijena?.toString(),
      'vrstaId': widget.product?.vrstaId?.toString(),
      'jedinicaMjereId': widget.product?.jedinicaMjereId?.toString()
    };
    _jediniceMjereProvider = context.read<JediniceMjereProvider>();
    _vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    _productProvider = context.read<ProductProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
    jediniceMjereResult = await _jediniceMjereProvider.get();
    print(jediniceMjereResult?.result[0].jedinicaMjereId);

    vrsteProizvodaResult = await _vrsteProizvodaProvider.get();
    print(vrsteProizvodaResult?.result[0].vrstaId);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: this.widget.product?.naziv ?? "Product Details",
      child: _buildForm(),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Sifra"),
                    name: 'sifra',
                    onChanged: (val) {
                      print(val); // Print the text value write into TextField
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Naziv"),
                    name: 'naziv',
                    onChanged: (val) {
                      print(val); // Print the text value write into TextField
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: FormBuilderDropdown<String>(
                  name: 'vrstaId',
                  decoration: InputDecoration(
                    labelText: 'Vrsta proizvoda',
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['vrstaId']?.reset();
                      },
                    ),
                    hintText: 'Select Gender',
                  ),
                   items: vrsteProizvodaResult?.result
                          .map((item) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: item.vrstaId.toString(),
                                child: Text(item.naziv ?? ""),
                              ))
                          .toList() ??
                      [],
                )),
                SizedBox(
              width: 10,
            ),
            Expanded(
                child: FormBuilderDropdown<String>(
              name: 'jedinicaMjereId',
              decoration: InputDecoration(
                labelText: 'Jedinica mjere',
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _formKey.currentState!.fields['jedinicaMjereId']?.reset();
                  },
                ),
                hintText: 'Jedinica mjere',
              ),
              items: jediniceMjereResult?.result
                      .map((item) => DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: item.jedinicaMjereId.toString(),
                            child: Text(item.naziv ?? ""),
                          ))
                      .toList() ??
                  [],
            )),
              ],
            )
          ],
        ));
  }
}
