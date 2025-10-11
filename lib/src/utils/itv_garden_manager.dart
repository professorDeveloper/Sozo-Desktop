import 'dart:convert';
import 'package:http/http.dart' as http;

class Category {
  final String key;
  final String name;

  Category(this.key, this.name);
}

class Country {
  final String code;
  final String name;

  Country(this.code, this.name);
}

class Channel {
  final String nanoid;
  final String name;
  final List<String> iptvUrls;
  final List<String> youtubeUrls;
  final String language;
  final String country;
  final bool isGeoBlocked;

  Channel({
    required this.nanoid,
    required this.name,
    required this.iptvUrls,
    required this.youtubeUrls,
    required this.language,
    required this.country,
    required this.isGeoBlocked,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      nanoid: json['nanoid'] ?? '',
      name: json['name'] ?? '',
      iptvUrls: List<String>.from(json['iptv_urls'] ?? []),
      youtubeUrls: List<String>.from(json['youtube_urls'] ?? []),
      language: json['language'] ?? '',
      country: json['country'] ?? '',
      isGeoBlocked: json['isGeoBlocked'] ?? false,
    );
  }
}

class GitHubFile {
  final String name;
  final String type;

  GitHubFile(this.name, this.type);

  factory GitHubFile.fromJson(Map<String, dynamic> json) {
    return GitHubFile(json['name'] ?? '', json['type'] ?? '');
  }
}

class GardenDataManager {
  static final Map<String, String> _isoCountryNames = {
    "ad": "Andorra",
    "ae": "United Arab Emirates",
    "af": "Afghanistan",
    "ag": "Antigua and Barbuda",
    "al": "Albania",
    "am": "Armenia",
    "ao": "Angola",
    "ar": "Argentina",
    "at": "Austria",
    "au": "Australia",
    "aw": "Aruba",
    "az": "Azerbaijan",
    "ba": "Bosnia and Herzegovina",
    "bd": "Bangladesh",
    "be": "Belgium",
    "bf": "Burkina Faso",
    "bg": "Bulgaria",
    "bh": "Bahrain",
    "bj": "Benin",
    "bm": "Bermuda",
    "bn": "Brunei Darussalam",
    "bo": "Bolivia",
    "bq": "Bonaire, Sint Eustatius and Saba",
    "br": "Brazil",
    "bs": "Bahamas",
    "by": "Belarus",
    "ca": "Canada",
    "cd": "Congo, Democratic Republic of the",
    "ch": "Switzerland",
    "ci": "Côte d'Ivoire",
    "cl": "Chile",
    "cm": "Cameroon",
    "cn": "China",
    "co": "Colombia",
    "cr": "Costa Rica",
    "cu": "Cuba",
    "cv": "Cabo Verde",
    "cw": "Curaçao",
    "cy": "Cyprus",
    "cz": "Czechia",
    "de": "Germany",
    "dj": "Djibouti",
    "dk": "Denmark",
    "do": "Dominican Republic",
    "dz": "Algeria",
    "ec": "Ecuador",
    "ee": "Estonia",
    "eg": "Egypt",
    "eh": "Western Sahara",
    "er": "Eritrea",
    "es": "Spain",
    "et": "Ethiopia",
    "fi": "Finland",
    "fo": "Faroe Islands",
    "fr": "France",
    "ge": "Georgia",
    "gh": "Ghana",
    "gl": "Greenland",
    "gm": "Gambia",
    "gn": "Guinea",
    "gp": "Guadeloupe",
    "gq": "Equatorial Guinea",
    "gr": "Greece",
    "gt": "Guatemala",
    "gu": "Guam",
    "gy": "Guyana",
    "hk": "Hong Kong",
    "hn": "Honduras",
    "hr": "Croatia",
    "ht": "Haiti",
    "hu": "Hungary",
    "id": "Indonesia",
    "ie": "Ireland",
    "il": "Israel",
    "in": "India",
    "iq": "Iraq",
    "ir": "Iran",
    "is": "Iceland",
    "it": "Italy",
    "jm": "Jamaica",
    "jo": "Jordan",
    "jp": "Japan",
    "ke": "Kenya",
    "kh": "Cambodia",
    "kn": "Saint Kitts and Nevis",
    "kr": "Korea, Republic of",
    "kw": "Kuwait",
    "kz": "Kazakhstan",
    "la": "Lao People's Democratic Republic",
    "lb": "Lebanon",
    "lc": "Saint Lucia",
    "lk": "Sri Lanka",
    "lt": "Lithuania",
    "lu": "Luxembourg",
    "lv": "Latvia",
    "ly": "Libya",
    "ma": "Morocco",
    "mc": "Monaco",
    "md": "Moldova",
    "me": "Montenegro",
    "mk": "North Macedonia",
    "ml": "Mali",
    "mm": "Myanmar",
    "mn": "Mongolia",
    "mq": "Martinique",
    "mt": "Malta",
    "mu": "Mauritius",
    "mv": "Maldives",
    "mx": "Mexico",
    "my": "Malaysia",
    "mz": "Mozambique",
    "na": "Namibia",
    "ng": "Nigeria",
    "ni": "Nicaragua",
    "nl": "Netherlands",
    "no": "Norway",
    "np": "Nepal",
    "nz": "New Zealand",
    "om": "Oman",
    "pa": "Panama",
    "pe": "Peru",
    "pf": "French Polynesia",
    "ph": "Philippines",
    "pk": "Pakistan",
    "pl": "Poland",
    "pr": "Puerto Rico",
    "ps": "Palestine",
    "pt": "Portugal",
    "py": "Paraguay",
    "qa": "Qatar",
    "ro": "Romania",
    "rs": "Serbia",
    "ru": "Russian Federation",
    "rw": "Rwanda",
    "sa": "Saudi Arabia",
    "sd": "Sudan",
    "se": "Sweden",
    "sg": "Singapore",
    "si": "Slovenia",
    "sk": "Slovakia",
    "sm": "San Marino",
    "sn": "Senegal",
    "so": "Somalia",
    "sr": "Suriname",
    "sv": "El Salvador",
    "sx": "Sint Maarten",
    "sy": "Syrian Arab Republic",
    "td": "Chad",
    "tg": "Togo",
    "th": "Thailand",
    "tj": "Tajikistan",
    "tn": "Tunisia",
    "tr": "Türkiye",
    "tt": "Trinidad and Tobago",
    "tw": "Taiwan",
    "ua": "Ukraine",
    "ug": "Uganda",
    "uk": "United Kingdom",
    "us": "United States",
    "uy": "Uruguay",
    "uz": "Uzbekistan",
    "ve": "Venezuela",
    "vg": "Virgin Islands (British)",
    "vi": "Virgin Islands (U.S.)",
    "vn": "Viet Nam",
    "ws": "Samoa",
    "xk": "Kosovo",
    "ye": "Yemen",
    "za": "South Africa",
    "zw": "Zimbabwe"
  };

  static final http.Client _client = http.Client();

  static Future<List<Category>> loadCategoriesFromApi() async {
    const apiUrl =
        'https://api.github.com/repos/professorDeveloper/tv-garden-channel-list/contents/channels/raw/categories';

    try {
      final response = await _client.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw Exception('Unexpected response code: ${response.statusCode}');
      }

      final json = response.body;
      if (json.trim().isEmpty) {
        throw Exception('Empty response body');
      }

      final List<dynamic> files = jsonDecode(json);
      return files
          .where((file) =>
      file['type'] == 'file' &&
          file['name'].endsWith('.json') &&
          file['name'] != 'countries_metadata.json')
          .map((file) {
        final key = file['name'].replaceAll('.json', '');
        final name = key
            .split('-')
            .map((part) => part[0].toUpperCase() + part.substring(1))
            .join(' ');
        return Category(key, name);
      })
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      print('Error loading categories from API: $e. Returning empty list.');
      return [];
    }
  }

  static Future<List<Country>> loadCountriesFromApi() async {
    const apiUrl =
        'https://api.github.com/repos/professorDeveloper/tv-garden-channel-list/contents/channels/raw/countries';

    try {
      final response = await _client.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw Exception('Unexpected response code: ${response.statusCode}');
      }

      final json = response.body;
      if (json.trim().isEmpty) {
        throw Exception('Empty response body');
      }

      final List<dynamic> files = jsonDecode(json);
      return files
          .where((file) => file['type'] == 'file' && file['name'].endsWith('.json'))
          .map((file) {
        final code = file['name'].replaceAll('.json', '').toLowerCase();
        final name = _isoCountryNames[code] ?? code.toUpperCase();
        return Country(code, name);
      })
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      print('Error loading countries from API: $e. Returning empty list.');
      return [];
    }
  }

  static Future<List<Channel>> loadChannelsForCountry(String countryCode) async {
    final url =
        'https://raw.githubusercontent.com/professorDeveloper/tv-garden-channel-list/main/channels/raw/countries/${countryCode.toLowerCase()}.json';

    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Unexpected response code: ${response.statusCode}');
      }

      final json = response.body;
      if (json.trim().isEmpty) {
        throw Exception('JSON content is empty');
      }

      final List<dynamic> channels = jsonDecode(json);
      return channels.map((json) => Channel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading channels for $countryCode: $e. Returning empty list.');
      return [];
    }
  }

  static Future<List<Channel>> loadChannelsForCategory(String categoryKey) async {
    final url =
        'https://raw.githubusercontent.com/professorDeveloper/tv-garden-channel-list/main/channels/raw/categories/${categoryKey.toLowerCase()}.json';

    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Unexpected response code: ${response.statusCode}');
      }

      final json = response.body;
      if (json.trim().isEmpty) {
        throw Exception('JSON content is empty');
      }

      final List<dynamic> channels = jsonDecode(json);
      return channels.map((json) => Channel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading channels for category $categoryKey: $e. Returning empty list.');
      return [];
    }
  }
}