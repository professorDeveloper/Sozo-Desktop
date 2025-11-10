// lib/parsers/hentai_mama.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sozodesktop/src/parser/utils.dart';
import 'package:html/parser.dart' show parse;
import 'base_parser.dart';
import 'models/episode_data.dart';
import 'models/kiwi.dart';
import 'models/response.dart';

enum VideoType { m3u8, container }

class Video {
  final String? id;
  final VideoType type;
  final String url;
  final int? size;
  Video({this.id, required this.type, required this.url, this.size});
}

class HentaiMama extends BaseParser {
  @override
  final String name = "hentaimama";
  @override
  final String saveName = "hentai_mama";
  @override
  final String hostUrl = "https://hentaimama.io";
  @override
  final bool isNSFW = true;
  @override
  final String language = "jp";

  @override
  Future<List<ShowResponse>> search(String query) async {
    final q = query.length > 7 ? query.substring(0, 7) : query;
    final url = "$hostUrl/?s=${q.replaceAll(' ', '+')}";
    final doc = await getJsoup(url);
    return doc.querySelectorAll('div.result-item article').map((e) {
      final a = e.querySelector('div.title a')!;
      final img = e.querySelector('div.image img')!;
      return ShowResponse(name: a.text, link: a.attributes['href']!, coverUrl: img.attributes['src']!);
    }).toList();
  }

  Future<List<Data>> loadEpisodes(String link) async {
    final doc = await getJsoup(link);
    final items = doc.querySelectorAll('div#episodes article').toList().reversed;
    return items.map((e) {
      final ep = e.querySelector('div.data h3')!.text.replaceAll('Episode', '').trim();
      final url = e.querySelector('div.season_m a')!.attributes['href']!;
      final thumb = e.querySelector('div.poster img')!.attributes['data-src'] ?? '';
      return Data(episode: int.parse(ep), session: url, snapshot: thumb);
    }).toList();
  }

  Future<Kiwi> loadVideoServers(String link) async {
    final page = await httpClient.get(Uri.parse(link));
    final doc = parse(page.body);
    final input = doc.querySelector('#post_report > input:nth-child(5)');

    if (input == null || input.attributes['value'] == null) {
      throw Exception('Anime ID not found');
    }

    final id = input.attributes['value']!;

    final resp = await httpClient.post(
      Uri.parse('$hostUrl/wp-admin/admin-ajax.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'action': 'get_player_contents', 'a': id},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to load video servers');
    }

    final urls = (jsonDecode(resp.body) as List).cast<String>();
    if (urls.isEmpty) throw Exception('No video URLs found');

    final srcMatch = RegExp(r'src="([^"]+)"').firstMatch(urls.first);
    final src = srcMatch?.group(1) ?? '';

    return Kiwi(session: src, provider: 'Mirror 0', url: '');
  }
  Future<Video> extract(Kiwi server) async {
    final doc = await getJsoup(server.session);
    final direct = doc.querySelector('video>source')?.attributes['src'];
    if (direct != null && direct.isNotEmpty) return Video(type: VideoType.container, url: direct);
    final raw = doc.body?.innerHtml ?? '';
    final jsonStr = raw.contains('sources: [') ? raw.split('sources: [').last.split('],').first : '';
    if (jsonStr.isEmpty) return Video(type: VideoType.container, url: '');
    final list = (jsonDecode('[$jsonStr]') as List).cast<Map<String, dynamic>>();
    final first = list.first;
    final type = first['type'] == 'hls' ? VideoType.m3u8 : VideoType.container;
    return Video(type: type, url: first['file']);
  }
}