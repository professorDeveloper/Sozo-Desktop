// lib/utils.dart
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

final httpClient = http.Client();

Future<Document> getJsoup(String url, [Map<String, String>? headers]) async {
  final resp = await httpClient.get(Uri.parse(url), headers: headers);
  return parse(resp.body);
}

String? unpackJs(String packed) {
  final regex = RegExp(r'eval\(function\(p,a,c,k,e,d\)');
  return regex.hasMatch(packed) ? packed : packed;
}