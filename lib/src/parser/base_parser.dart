// lib/parsers/base_parser.dart
abstract class BaseParser {
  String get name => "";
  String get saveName => "";
  String get hostUrl => "";
  bool get isNSFW => false;
  String get language => "English";

  String encode(String input) => Uri.encodeComponent(input).replaceAll('+', '%20');
  String decode(String input) => Uri.decodeFull(input);
}