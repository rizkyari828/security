import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/routes/app_pages.dart';

class FcmNotificationService extends GetxService {
  FcmNotificationService({FirebaseMessaging? messaging})
    : messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging messaging;

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onOpenedAppSub;
  final Set<String> _handledTapMessageKeys = <String>{};
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _onMessageSub = FirebaseMessaging.onMessage.listen(_handleForeground);
    _onOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpened,
    );

    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      _handleOpened(initial);
    }
  }

  void _handleForeground(RemoteMessage message) {
    final title = _firstNonEmpty(
      message.notification?.title,
      message.data['title']?.toString(),
      'Notifikasi',
    );
    final body = _firstNonEmpty(
      message.notification?.body,
      message.data['body']?.toString(),
      message.data['message']?.toString(),
      message.data.isEmpty ? '' : jsonEncode(message.data),
      'Pesan baru',
    );

    if (title.trim().isEmpty && body.trim().isEmpty) return;
    Get.snackbar(
      title,
      body,
      icon: const Icon(Icons.notifications, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  void _handleOpened(RemoteMessage message) {
    final key =
        (message.messageId ?? '').trim().isNotEmpty
        ? message.messageId!.trim()
        : '${message.sentTime?.millisecondsSinceEpoch ?? 0}-${message.data.hashCode}';
    if (!_handledTapMessageKeys.add(key)) return;

    final type = (message.data['type'] ?? '').toString().trim().toLowerCase();
    final route = _routeForType(type);
    if (route == null) return;

    Future<void>.delayed(Duration.zero, () {
      if (Get.currentRoute == route) return;
      Get.toNamed(route);
    });
  }

  String? _routeForType(String type) {
    switch (type) {
      case 'izin':
        return Routes.LEAVE;
      case 'cuti':
        return Routes.BENEFIT;
      case 'overtime':
        return Routes.PROSPEK;
      case 'task':
        return Routes.HOME;
      default:
        return Routes.HOME;
    }
  }

  String _firstNonEmpty(String? a, String? b, [String? c, String? d, String? e]) {
    final items = <String?>[a, b, c, d, e];
    for (final item in items) {
      final value = (item ?? '').trim();
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  @override
  void onClose() {
    _onMessageSub?.cancel();
    _onOpenedAppSub?.cancel();
    super.onClose();
  }
}
