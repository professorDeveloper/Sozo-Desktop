// lib/js_unpacker.dart
import 'dart:math';

class JsUnpacker {
  final String? packedJS;

  JsUnpacker(this.packedJS);

  /// Detects whether the javascript is P.A.C.K.E.R coded.
  bool detect() {
    if (packedJS == null) return false;
    final js = packedJS!.replaceAll(' ', '');
    final regex = RegExp(r'eval\(function\(p,a,c,k,e,[rd]');
    return regex.hasMatch(js);
  }

  /// Unpack the javascript.
  /// Returns the unpacked code, or null if it fails.
  String? unpack() {
    final js = packedJS;
    if (js == null) return null;

    try {
      final pattern = RegExp(
        r"""}\s*\('(.*)',\s*(.*?),\s*(\d+),\s*'(.*?)'\.split\('\|'\)""",
        dotAll: true,
      );

      final match = pattern.firstMatch(js);
      if (match != null && match.groupCount == 4) {
        // payload string
        var payload = match.group(1)!;
        // unescape \'
        payload = payload.replaceAll("\\'", "'");

        final radixStr = match.group(2)!;
        final countStr = match.group(3)!;
        final symtab =
        match.group(4)!.split('|'); // same as Kotlin's split("\\|".toRegex())

        var radix = 36;
        var count = 0;

        try {
          radix = int.parse(radixStr);
        } catch (_) {}

        try {
          count = int.parse(countStr);
        } catch (_) {}

        if (symtab.length != count) {
          throw Exception('Unknown p.a.c.k.e.r. encoding');
        }

        final unbase = Unbase(radix);

        // Replace all words with their decoded versions
        final wordPattern = RegExp(r'\b\w+\b');

        final decoded = payload.replaceAllMapped(wordPattern, (m) {
          final word = m.group(0)!;
          int x;
          try {
            x = unbase.unbase(word);
          } catch (_) {
            return word; // can't decode -> leave as is
          }

          if (x >= 0 && x < symtab.length) {
            final value = symtab[x];
            if (value.isNotEmpty) {
              return value;
            }
          }
          return word;
        });

        return decoded;
      }
    } catch (e) {
      // ignore or print if you want
      // print(e);
    }

    return null;
  }
}

class Unbase {
  final int radix;

  static const String _alphabet62 =
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static const String _alphabet95 =
      ' !"#\$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';

  String? _alphabet;
  Map<String, int>? _dictionary;

  Unbase(this.radix) {
    if (radix > 36) {
      if (radix < 62) {
        _alphabet = _alphabet62.substring(0, radix);
      } else if (radix >= 63 && radix <= 94) {
        _alphabet = _alphabet95.substring(0, radix);
      } else if (radix == 62) {
        _alphabet = _alphabet62;
      } else if (radix == 95) {
        _alphabet = _alphabet95;
      }

      if (_alphabet != null) {
        _dictionary = <String, int>{};
        for (var i = 0; i < _alphabet!.length; i++) {
          _dictionary![_alphabet![i]] = i;
        }
      }
    }
  }

  int unbase(String str) {
    // No custom alphabet → use normal int.parse with radix
    if (_alphabet == null || _dictionary == null) {
      return int.parse(str, radix: radix);
    }

    // Custom alphabet
    final tmp = str.split('').reversed.join();
    var ret = 0;
    for (var i = 0; i < tmp.length; i++) {
      final ch = tmp[i];
      final digit = _dictionary![ch] ?? 0;
      ret += (pow(radix, i) as num).toInt() * digit;
    }
    return ret;
  }
}

// === Companion object part from Kotlin ===

const List<int> _c = [
  0x63,
  0x6f,
  0x6d,
  0x2e,
  0x67,
  0x6f,
  0x6f,
  0x67,
  0x6c,
  0x65,
  0x2e,
  0x61,
  0x6e,
  0x64,
  0x72,
  0x6f,
  0x69,
  0x64,
  0x2e,
  0x67,
  0x6d,
  0x73,
  0x2e,
  0x61,
  0x64,
  0x73,
  0x2e,
  0x4d,
  0x6f,
  0x62,
  0x69,
  0x6c,
  0x65,
  0x41,
  0x64,
  0x73
];

const List<int> _z = [
  0x63,
  0x6f,
  0x6d,
  0x2e,
  0x66,
  0x61,
  0x63,
  0x65,
  0x62,
  0x6f,
  0x6f,
  0x6b,
  0x2e,
  0x61,
  0x64,
  0x73,
  0x2e,
  0x41,
  0x64,
];

extension JsUnpackerLoadExt on String {
  /// Dart'da Class.forName yo'q, shuning uchun bu faqat
  /// klass nomi stringini qaytaradi.
  String? load() {
    try {
      var load = this;

      for (var q = 0; q < _c.length; q++) {
        if (_c[q % 4] > 270) {
          load += _c[q % 3].toString();
        } else {
          load += String.fromCharCode(_c[q]);
        }
      }

      // Kotlin: load.substring(load.length - c.size, load.length)
      final clsName = load.substring(load.length - _c.length);
      return clsName;
    } catch (_) {
      try {
        var f = String.fromCharCode(_c[2]);
        for (final code in _z) {
          f += String.fromCharCode(code);
        }
        // substring(0b001, f.length) == substring(1)
        return f.substring(1);
      } catch (_) {
        return null;
      }
    }
  }
}
