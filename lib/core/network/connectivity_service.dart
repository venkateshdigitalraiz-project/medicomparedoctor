import 'dart:async';
import 'dart:io';
import 'package:medicompare/core/network/network_info.dart';

class ConnectivityServiceImpl implements NetworkInfo {
  final Duration checkTimeout;
  final Duration checkInterval;

  bool _lastConnectionState = true;
  final StreamController<bool> _connectivityStreamController = StreamController<bool>.broadcast();
  Timer? _timer;

  // Cache variables to prevent duplicate lookups
  bool? _cachedConnectionState;
  DateTime? _lastCheckTime;
  final Duration _cacheDuration = const Duration(seconds: 1);

  ConnectivityServiceImpl({
    this.checkTimeout = const Duration(seconds: 3),
    this.checkInterval = const Duration(seconds: 5),
  }) {
    _startMonitoring();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(checkInterval, (timer) async {
      final current = await _checkConnectionDirectly();
      if (current != _lastConnectionState) {
        _lastConnectionState = current;
        _connectivityStreamController.add(current);
      }
    });
  }

  Future<bool> _checkConnectionDirectly() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(checkTimeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> get isConnected async {
    final now = DateTime.now();
    if (_cachedConnectionState != null &&
        _lastCheckTime != null &&
        now.difference(_lastCheckTime!) < _cacheDuration) {
      return _cachedConnectionState!;
    }

    final isConnectedNow = await _checkConnectionDirectly();
    _cachedConnectionState = isConnectedNow;
    _lastCheckTime = now;
    return isConnectedNow;
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityStreamController.stream;

  void dispose() {
    _timer?.cancel();
    _connectivityStreamController.close();
  }
}
