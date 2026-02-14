import 'package:staffku/api/api_constants.dart';
import 'package:staffku/shared/utils/url_utils.dart';

String resolveSosImageUrl(String raw) {
  final input = raw.trim();
  if (input.isEmpty) return '';

  final normalized = normalizeUrlForBase(ApiConstants.baseUrl, input).trim();
  if (normalized.isEmpty) return '';

  final parsed = Uri.tryParse(normalized);
  if (parsed != null && parsed.hasScheme && parsed.host.isNotEmpty) {
    return normalized;
  }

  if (normalized.startsWith('/')) {
    return '${ApiConstants.baseUrl}$normalized';
  }

  return '${ApiConstants.baseUrl}/$normalized';
}

