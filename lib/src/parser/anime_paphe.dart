// lib/parsers/anime_pahe.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sozodesktop/src/parser/models/response.dart';
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
    if (resp.statusCode != 200) return null;
    return EpisodeData.fromJson(jsonDecode(resp.body));
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
    final doc = await getJsoup(url, {"User-Agent": _ua, "Referer": hostUrl});
    final script = doc
        .querySelectorAll('script')
        .firstWhere(
          (s) => s.innerHtml.contains('eval(function(p,a,c,k,e,d)'),
          orElse: () => throw Exception('Packed script not found'),
        );
    final unpacked = unpackJs(script.innerHtml) ?? '';
    final m3u8 =
        RegExp(r'https?://[^\s]+\.m3u8').firstMatch(unpacked)?.group(0) ?? '';
    return _m3u8ToMp4(m3u8, 'file');
  }

  String _m3u8ToMp4(String m3u8, String file) {
    if (m3u8.isEmpty) return '';
    final uri = Uri.parse(m3u8);
    final segments = uri.pathSegments;
    if (segments.isEmpty) return '';
    final newSegments = segments.sublist(0, segments.length - 1);
    newSegments[0] = 'mp4'; // /stream -> /mp4
    final path = '/${newSegments.join('/')}';
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: path,
      queryParameters: {'file': '$file.mp4'},
    ).toString();
  }}
