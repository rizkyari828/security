import 'package:flutter_test/flutter_test.dart';
import 'package:staffku/models/response/attendance/attendance_validate.dart';

void main() {
  group('AttendanceValidateResponse', () {
    test('parses face_id list string embedding correctly', () {
      final response = AttendanceValidateResponse.fromJson({
        'status': '200',
        'message': 'sukses',
        'Data': [
          {
            'flag': '1',
            'absen_in': '10:51:11',
            'absen_out': '10:52:18',
            'jarak': '0',
            'lat': -7.75,
            'long': 110.48,
            'face_id': [
              '[-0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4]'
            ],
          },
        ],
      });

      final first = response.data!.first;
      expect(first.faceEmbeddings.length, 1);
      expect(first.faceEmbeddings.first.length, 64);
      expect(first.hasValidFaceEmbeddings, isTrue);
    });

    test('parses face_id when backend returns raw string', () {
      final response = AttendanceValidateResponse.fromJson({
        'status': '200',
        'message': 'ok',
        'Data': [
          {
            'flag': '0',
            'lat': '-6.2',
            'long': '106.8',
            'face_id':
                '[-0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4, 0.5, -0.6, 0.7, -0.8, 0.9, -1.0, 0.1, 0.2, 0.3, -0.4]',
          },
        ],
      });

      final first = response.data!.first;
      expect(first.latitude, closeTo(-6.2, 0.0001));
      expect(first.longitude, closeTo(106.8, 0.0001));
      expect(first.faceEmbeddings.length, 1);
      expect(first.hasValidFaceEmbeddings, isTrue);
    });
  });
}
