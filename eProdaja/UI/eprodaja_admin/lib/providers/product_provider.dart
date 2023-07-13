import 'package:eprodaja_admin/providers/base_provider.dart';
import '../models/product.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider(): super("Proizvodi");

  @override
  Product fromJson(data) {
    // TODO: implement fromJson
    return Product.fromJson(data);
  }
 
}
