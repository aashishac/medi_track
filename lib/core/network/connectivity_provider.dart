import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  // we assume the inital state is true (connected)
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late StreamSubscription<InternetStatus> _subscription;

  ConnectivityProvider() {
    _initConnectivityListner();
  }

  void _initConnectivityListner() {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      bool receivedConnectionStatus = status == .connected;

      // only notify listeners if the status actually changes
      if (_isConnected != receivedConnectionStatus) {
        _isConnected = receivedConnectionStatus;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
