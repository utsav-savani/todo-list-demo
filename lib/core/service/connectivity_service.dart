import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Stream to listen for connectivity changes
  Stream<ConnectivityResult> get connectivityStream {
    return Connectivity().onConnectivityChanged.map((result) {
      return result.last;
    }).distinct();
  }

  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result.last != ConnectivityResult.none;
  }
}
