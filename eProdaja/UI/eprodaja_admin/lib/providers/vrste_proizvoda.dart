import 'package:eprodaja_admin/providers/base_provider.dart';
import '../models/vrste_proizvoda.dart';

class VrsteProizvodaProvider extends BaseProvider<VrsteProizvoda> {
  VrsteProizvodaProvider(): super("VrsteProizvoda");

  @override
  VrsteProizvoda fromJson(data) {
    // TODO: implement fromJson
    return VrsteProizvoda.fromJson(data);
  }
 
}