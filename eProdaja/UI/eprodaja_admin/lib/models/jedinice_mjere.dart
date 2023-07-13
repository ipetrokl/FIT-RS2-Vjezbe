import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'jedinice_mjere.g.dart';

@JsonSerializable()
class JediniceMjere {
  int? jedinicaMjereId;
  String? naziv;

  JediniceMjere(this.jedinicaMjereId, this.naziv);

  factory JediniceMjere.fromJson(Map<String, dynamic> json) =>
      _$JediniceMjereFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$JediniceMjereToJson(this);
}
