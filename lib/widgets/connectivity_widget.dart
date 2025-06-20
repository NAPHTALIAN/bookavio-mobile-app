import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class ConnectivityWidget extends StatefulWidget {
  final Widget child;
  final Widget? noConnectionWidget;
  
  const ConnectivityWidget({
    super.key,
    required this.child,
    this.noConnectionWidget,
  });

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize();
    _connectivityService.connectionStatus.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return widget.noConnectionWidget ?? _buildDefaultNoConnectionWidget();
    }
    return widget.child;
  }

  Widget _buildDefaultNoConnectionWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _connectivityService.checkConnection();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
} 