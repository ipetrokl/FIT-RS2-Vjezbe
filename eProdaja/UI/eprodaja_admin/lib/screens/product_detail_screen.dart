import 'dart:convert';
import 'dart:io';

import 'package:eprodaja_admin/models/jedinice_mjere.dart';
import 'package:eprodaja_admin/models/search_result.dart';
import 'package:eprodaja_admin/models/vrste_proizvoda.dart';
import 'package:eprodaja_admin/providers/jedinice_mjere.dart';
import 'package:eprodaja_admin/providers/vrste_proizvoda.dart';
import 'package:eprodaja_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
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
  bool isLoading = true;

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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: this.widget.product?.naziv ?? "Product Details",
        child: Column(
          children: [
            isLoading ? Container() : _buildForm(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState?.saveAndValidate();
                        print(_formKey.currentState?.value);

                        var request = Map.from(_formKey.currentState!.value);

                        request['Slika'] = _base64image;

                        try {
                          if (widget.product == null) {
                            await _productProvider
                                .insert(request);
                          } else {
                            await _productProvider.update(
                                widget.product!.proizvodId!,
                                request);
                          }
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OK"))
                                    ],
                                  ));
                        }
                      },
                      child: Text("Sacuvaj")),
                )
              ],
            )
          ],
        ));
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
                        _formKey.currentState!.fields['jedinicaMjereId']
                            ?.reset();
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
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Cijena"),
                    name: 'cijena',
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
                    child: FormBuilderField(
                        name: "imageId",
                        builder: ((field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                label: Text("Odaberite sliku"),
                                errorText: field.errorText),
                            child: ListTile(
                              leading: Icon(Icons.photo),
                              title: Text("Select image"),
                              trailing: Icon(Icons.file_upload),
                              onTap: getImage,
                            ),
                          );
                        })))
              ],
            )
          ],
        ));
  }

  File? _image;
  String? _base64image;
  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64image = base64Encode(_image!.readAsBytesSync());
    }
  }
}
