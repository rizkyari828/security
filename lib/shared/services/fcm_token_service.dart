import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staffku/api/api.dart';
import 'package:staffku/models/request/update_fcm_profile_request.dart';
import 'package:staffku/shared/constants/storage.dart';

class FcmTokenService extends GetxService {
  FcmTokenService({
    required this.apiRepository,
    required this.prefs,
    FirebaseMessaging? messaging,
  }) : messaging = messaging ?? FirebaseMessaging.instance;

  final ApiRepository apiRepository;
  final SharedPreferences prefs;
  final FirebaseMessaging messaging;

  StreamSubscription<String>? _refreshSub;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _refreshSub = messaging.onTokenRefresh.listen((newToken) async {
      await _syncTokenInternal(newToken);
    });
  }

  Future<void> initAndSync() async {
    await init();
    await syncToken();
  }

  Future<void> syncToken() async {
    final token = await messaging.getToken();
    await _syncTokenInternal(token);
  }

  Future<void> _syncTokenInternal(String? token) async {
    if (token == null || token.trim().isEmpty) return;
    prefs.setString(StorageConstants.fcmToken, token);

    final hasAuthToken =
        (prefs.getString(StorageConstants.token) ?? '').trim().isNotEmpty;
    if (!hasAuthToken) return;

    final lastSynced =
        (prefs.getString(StorageConstants.fcmTokenSynced) ?? '').trim();
    if (lastSynced == token.trim()) return;

    try {
      final res = await apiRepository.updateFcmProfile(
        UpdateFcmProfileRequest(fcmToken: token.trim()),
      );

      if (res?.error == false) {
        prefs.setString(StorageConstants.fcmTokenSynced, token.trim());
      }
    } catch (_) {
      // ignore: best effort, will retry on next app start / refresh
    }
  }

  @override
  void onClose() {
    _refreshSub?.cancel();
    super.onClose();
  }
}
