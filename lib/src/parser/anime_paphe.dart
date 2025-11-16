// lib/parsers/anime_pahe.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sozodesktop/src/parser/models/response.dart';
import 'package:sozodesktop/src/parser/unpacker.dart';
import 'package:sozodesktop/src/parser/utils.dart';
import 'base_parser.dart';
import 'models/episode_data.dart';

class AnimePahe extends BaseParser {
  @override
  final String name = "AniPahe";
  @override
  final String saveName = "anipahe";
  @override
  final String hostUrl = "https://animepahe.si";
  @override
  final String language = "en";

  static const _ua =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36";

  Future<Map<String, String>> _headers() async {
    final cookie = "";
    final map = {
      "User-Agent": _ua,
      "Accept": "application/json, text/javascript, */*; q=0.01",
      "Accept-Language": "en-US,en;q=0.9",
      "DNT": "1",
    };
    if (cookie.isNotEmpty) map["Cookie"] = cookie;
    return map;
  }

  @override
  Future<List<ShowResponse>> search(String query) async {
    final headers = await _headers();
    final q = query.replaceAll(' ', '%20');
    final url = "$hostUrl/api?m=search&q=$q";
    final resp = await httpClient.get(Uri.parse(url), headers: headers);
    if (resp.statusCode != 200) return [];
    final json = jsonDecode(resp.body);
    final data = AnimePaheData.fromJson(json).data;
    return data
        .map(
          (e) => ShowResponse(
            name: e.title ?? '',
            link: e.session ?? '',
            coverUrl: e.poster ?? '',
          ),
        )
        .toList();
  }

  Future<EpisodeData?> loadEpisodes(String id, int page) async {
    final headers = await _headers();
    final url = "$hostUrl/api?m=release&id=$id&sort=episode_asc&page=$page";
    final resp = await httpClient.get(Uri.parse(url), headers: headers);
    print(resp.body.toString());
    if (resp.statusCode != 200) return null;
    var episodeData = EpisodeData.fromJson(jsonDecode(resp.body));
    var session = episodeData.data![0].session.toString();
    return episodeData;
  }

  Future<List<VideoOption>> getEpisodeVideo(String epId, String id) async {
    final headers = await _headers();
    final doc = await getJsoup("$hostUrl/play/$id/$epId", headers);
    final options = <VideoOption>[];
    final buttons = doc.querySelectorAll(
      'div#resolutionMenu button.dropdown-item',
    );
    for (final b in buttons) {
      final kwik = b.attributes['data-src'] ?? '';
      print("Salom:::" + kwik);
      final fansub = b.attributes['data-fansub'] ?? '';
      final res = b.attributes['data-resolution'] ?? '';
      final audio = b.attributes['data-audio'] ?? 'jpn';
      final active = b.classes.contains('active');
      final audioType = audio == 'eng' ? AudioType.dub : AudioType.sub;
      final badges = b.querySelectorAll('span.badge').map((e) => e.text);
      final quality = badges.firstWhere(
        (t) => t.contains('BD'),
        orElse: () => '',
      );
      options.add(
        VideoOption(
          kwikUrl: kwik,
          fansub: fansub,
          resolution: '${res}p',
          audioType: audioType,
          quality: quality,
          isActive: active,
          fullText: b.text,
        ),
      );
    }
    return options;
  }

  Future<String> extractVideo(String url) async {
    final doc = await getJsoup(
      url,
      {
        "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:101.0) Gecko/20100101 Firefox/101.0",
        "Referer": url,
        "Host": "kwik.cx",
        "Alt-Used": "kwik.cx",
        "Sec-Fetch-User": "?1",
      },
    );

    // 1. Packed scriptni topamiz
    final scriptElement = doc
        .querySelectorAll("script")
        .firstWhere(
          (s) => Packer.isPacked(s.innerHtml) || JsUnpacker(s.innerHtml).detect(),
      orElse: () => throw Exception("Packed script not found"),
    );

    final scriptSource = scriptElement.innerHtml;
    print("RAW SCRIPT:\n$scriptSource");

    // 2. Unpack qilishga harakat qilamiz (avval JsUnpacker, keyin Packer)
    String? unpacked;

    final jsUnpacker = JsUnpacker(scriptSource);
    if (jsUnpacker.detect()) {
      unpacked = jsUnpacker.unpack();
    } else if (Packer.isPacked(scriptSource)) {
      // Agar sizning eski Packer ham bo‘lsa:
      unpacked = Packer.unpack(scriptSource);
    }

    if (unpacked == null) {
      throw Exception("Failed to unpack JS");
    }

    print("UNPACKED:\n$unpacked");

    // 3. Escaped slashlarni tozalaymiz
    final clean = unpacked.replaceAll(r"\/", "/");

    // 4. .m3u8 linkni olish
    final match = RegExp(r"""https?://[^\s"']+\.m3u8""").firstMatch(clean);
    if (match == null) {
      throw Exception("m3u8 url not found");
    }

    return match.group(0)!;
  }

}
