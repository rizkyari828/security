import 'package:flutter_test/flutter_test.dart';
import 'package:staffku/shared/utils/url_utils.dart';

void main() {
  group('normalizeUrlForBase', () {
    const baseUrl = 'https://sales.lokalnet.id';

    test('converts absolute same-host URL to relative path', () {
      expect(
        normalizeUrlForBase(baseUrl, 'http://sales.lokalnet.id/file/a.pdf'),
        '/file/a.pdf',
      );
    });

    test('repairs missing-colon scheme and converts to relative', () {
      expect(
        normalizeUrlForBase(baseUrl, 'http//sales.lokalnet.id/file/a.pdf'),
        '/file/a.pdf',
      );
    });

    test('keeps relative paths', () {
      expect(normalizeUrlForBase(baseUrl, '/file/a.pdf'), '/file/a.pdf');
      expect(normalizeUrlForBase(baseUrl, 'file/a.pdf'), '/file/a.pdf');
    });

    test('keeps absolute different-host URL', () {
      expect(
        normalizeUrlForBase(baseUrl, 'https://cdn.example.com/file/a.pdf'),
        'https://cdn.example.com/file/a.pdf',
      );
    });
  });
}

