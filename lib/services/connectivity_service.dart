import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io' show InternetAddress;
import 'package:flutter/foundation.dart' show kIsWeb;

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  
  StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void initialize() {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _checkInternetConnection();
    });
    
    // Initial check
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    bool previousStatus = _isConnected;
    
    // Check if there's a network connection
    ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult != ConnectivityResult.none) {
      if (kIsWeb) {
        // For web, we'll assume connection is available if connectivity is not none
        _isConnected = true;
      } else {
        // For mobile platforms, we can do a more thorough check
        try {
          // Simple ping test for mobile platforms
          final result = await InternetAddress.lookup('google.com');
          _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        } catch (_) {
          _isConnected = false;
        }
      }
    } else {
      _isConnected = false;
    }
    
    // Only emit if status changed
    if (previousStatus != _isConnected) {
      _connectionStatusController.add(_isConnected);
    }
  }

  Future<bool> checkConnection() async {
    await _checkInternetConnection();
    return _isConnected;
  }

  void dispose() {
    _connectionStatusController.close();
  }
} 