import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:staffku/api/api_constants.dart';

const List<String> _fallbackIpv4 = <String>['104.21.82.161', '172.67.159.90'];

void applySalesHttpOverrides() {
  final host = Uri.parse(ApiConstants.baseUrl).host.trim();
  if (host.isEmpty) return;

  final fallback = host == 'sales.lokalnet.id'
      ? _fallbackIpv4.map(InternetAddress.new).toList(growable: false)
      : <InternetAddress>[];

  HttpOverrides.global = _SalesHttpOverrides(
    targetHost: host,
    fallbackIpv4: fallback,
  );

  if (kDebugMode) {
    print(
      '[HTTP] HttpOverrides enabled for host=$host fallback=${fallback.map((e) => e.address).toList(growable: false)}',
    );
  }
}

final class _SalesHttpOverrides extends HttpOverrides {
  _SalesHttpOverrides({required this.targetHost, required this.fallbackIpv4});

  final String targetHost;
  final List<InternetAddress> fallbackIpv4;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    client
        .connectionFactory = (Uri url, String? proxyHost, int? proxyPort) async {
      // If a proxy is configured, HttpClient will handle CONNECT + TLS itself.
      if (proxyHost != null && proxyPort != null) {
        return Socket.startConnect(proxyHost, proxyPort);
      }

      final port = url.hasPort && url.port != 0
          ? url.port
          : (url.scheme == 'https' ? 443 : 80);

      if (url.scheme != 'https') {
        return Socket.startConnect(url.host, port);
      }

      // For HTTPS we must return a SecureSocket, otherwise HttpClient will send
      // plain HTTP to port 443.
      if (url.host == targetHost && fallbackIpv4.isNotEmpty) {
        return _startSecureConnectWithFallback(
          targetHost: targetHost,
          port: port,
          addresses: fallbackIpv4,
        );
      }

      return _startSecureConnect(host: url.host, port: port);
    };

    // Avoid env proxy surprises; keep consistent with mobile expectations.
    client.findProxy = (_) => 'DIRECT';
    return client;
  }
}

Future<ConnectionTask<Socket>> _startSecureConnect({
  required String host,
  required int port,
}) async {
  final task = await Socket.startConnect(host, port);
  final secure = task.socket.then(
    (socket) => SecureSocket.secure(socket, host: host),
  );
  return ConnectionTask.fromSocket<Socket>(secure, task.cancel);
}

Future<ConnectionTask<Socket>> _startSecureConnectWithFallback({
  required String targetHost,
  required int port,
  required List<InternetAddress> addresses,
}) async {
  ConnectionTask<Socket>? activeTask;
  var cancelled = false;

  Future<Socket> connect() async {
    Object? firstError;

    for (final address in _rotate(addresses)) {
      if (cancelled) {
        throw SocketException('Connection attempt cancelled');
      }

      final task = await Socket.startConnect(address, port);
      activeTask = task;

      try {
        final socket = await task.socket;
        return await SecureSocket.secure(socket, host: targetHost);
      } catch (e) {
        firstError ??= e;
        try {
          final socket = await task.socket;
          socket.destroy();
        } catch (_) {}
      }
    }

    throw firstError ?? SocketException('Failed to connect');
  }

  void cancel() {
    cancelled = true;
    activeTask?.cancel();
  }

  return ConnectionTask.fromSocket<Socket>(connect(), cancel);
}

Iterable<T> _rotate<T>(List<T> items) sync* {
  if (items.isEmpty) return;
  final start = DateTime.now().millisecondsSinceEpoch % items.length;
  for (var i = 0; i < items.length; i++) {
    yield items[(start + i) % items.length];
  }
}
