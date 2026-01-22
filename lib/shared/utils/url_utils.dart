String normalizeUrlForBase(String baseUrl, String rawUrl) {
  final base = Uri.tryParse(baseUrl);
  final baseHost = base?.host;

  var input = rawUrl.trim();
  if (input.isEmpty) return input;

  input = input.replaceFirstMapped(
    RegExp(r'^(https?)//', caseSensitive: false),
    (m) => '${m[1]}://',
  );

  final uri = Uri.tryParse(input);
  if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
    if (baseHost != null && uri.host == baseHost) {
      final path = uri.path.startsWith('/') ? uri.path : '/${uri.path}';
      return uri.hasQuery ? '$path?${uri.query}' : path;
    }
    return uri.toString();
  }

  if (baseHost != null &&
      (input.startsWith(baseHost) || input.startsWith('//$baseHost'))) {
    input = input.replaceFirst('//$baseHost', '');
    input = input.replaceFirst(baseHost, '');
  }

  if (!input.startsWith('/')) input = '/$input';
  return input;
}
