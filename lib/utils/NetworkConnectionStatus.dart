import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class NetworkConnectionStatus {
  static final NetworkConnectionStatus _singleton = new NetworkConnectionStatus._internal();
  BuildContext _context;

  NetworkConnectionStatus._internal();

  static NetworkConnectionStatus getInstance() => _singleton;

  bool _hasConnection = false;
  StreamController connectionChangeController = new StreamController.broadcast();
  final Connectivity _connectivity = Connectivity();

  void initialize(BuildContext context) {
    _context = context;
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = _hasConnection;

    try {
      // final result = await InternetAddress.lookup('www.google.com');
      var connectivityResult = await (Connectivity().checkConnectivity());
      //below code can be optimised
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        _hasConnection = true;
      } else {
        _hasConnection = false;
      }
    } on SocketException catch (_) {
      _hasConnection = false;
    }
    if (previousConnection != _hasConnection) {
      connectionChangeController.add(_hasConnection);
    }
    return _hasConnection;
  }
}
