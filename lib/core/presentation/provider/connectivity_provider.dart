import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_firebase_demo/core/service/connectivity_service.dart';

final connectivityStreamProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivityService = ConnectivityService();
  return connectivityService.connectivityStream;
});

final connectivityProvider = FutureProvider<bool>((ref) async {
  final connectivityService = ConnectivityService();
  return connectivityService.isConnected(); // Returns true if connected, false if disconnected
});
