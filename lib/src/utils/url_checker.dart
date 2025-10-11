
bool checkYoutube(url) {
  final youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+$',
      caseSensitive: false);
  return youtubeRegex.hasMatch(url);

}