import 'package:eprodaja_admin/providers/base_provider.dart';

import '../models/jedinice_mjere.dart';

class JediniceMjereProvider extends BaseProvider<JediniceMjere> {
  JediniceMjereProvider(): super("JediniceMjere");

  @override
  JediniceMjere fromJson(data) {
    // TODO: implement fromJson
    return JediniceMjere.fromJson(data);
  }
 
}