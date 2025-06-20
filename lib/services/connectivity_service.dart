import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker = InternetConnectionChecker();
  
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
      // Check if there's actual internet connectivity
      _isConnected = await _internetChecker.hasConnection;
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