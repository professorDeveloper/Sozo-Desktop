// lib/utils.dart
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

final httpClient = http.Client();

Future<Document> getJsoup(String url, [Map<String, String>? headers]) async {
  final resp = await httpClient.get(
    Uri.parse(url),
    headers: headers,
  );
  return parse(resp.body);
}



class Packer {
  static bool isPacked(String source) {
    return source.contains("eval(function(p,a,c,k,e") ||
        source.contains("eval(function(p,a,c,k,e,");
  }

  static String? unpack(String source) {
    if (!isPacked(source)) return null;

    // 1. Capture the whole eval(function(...)...)(...)
    final evalPattern = RegExp(
      r"eval\(function\(p,a,c,k,e,[a-z]\)([\s\S]*?)\(([\s\S]*?)\)",
      multiLine: true,
    );

    final match = evalPattern.firstMatch(source);
    if (match == null) return null;

    final funcBody = match.group(1)!;
    final argsRaw = match.group(2)!;

    // 2. Extract args safely
    final args = _extractArgs(argsRaw);
    if (args.length < 4) return null;

    final p = args[0];
    final a = int.tryParse(args[1]) ?? 0;
    final c = int.tryParse(args[2]) ?? 0;
    final kList = args[3];

    final k = kList.contains("|")
        ? kList.split("|")
        : kList.replaceAll("'", "").split(",");

    // 3. Decode
    return _decode(p, a, c, k);
  }

  static List<String> _extractArgs(String raw) {
    final args = <String>[];
    int depth = 0;
    String buffer = "";

    for (var i = 0; i < raw.length; i++) {
      final ch = raw[i];

      if (ch == "(") depth++;
      if (ch == ")") depth--;

      if (ch == "," && depth == 0) {
        args.add(buffer.trim());
        buffer = "";
      } else {
        buffer += ch;
      }
    }

    args.add(buffer.trim());
    return args;
  }

  static String _decode(String p, int a, int c, List<String> k) {
    String encode(int c) {
      return c < a
          ? ""
          : encode(c ~/ a) +
          ((c % a) > 35
              ? String.fromCharCode(c % a + 29)
              : (c % a).toRadixString(36));
    }

    for (var i = c; i >= 0; i--) {
      if (i < k.length && k[i].isNotEmpty) {
        p = p.replaceAll(RegExp("\\b${encode(i)}\\b"), k[i]);
      }
    }

    return p;
  }
}

