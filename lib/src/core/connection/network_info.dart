import 'package:connectivity_plus/connectivity_plus.dart';

// abstract class NetworkInfo {
//   Future<bool>? get isConnected;
// }
//
// class NetworkInfoImpl implements NetworkInfo {
//   final DataConnectionChecker connectionChecker;
//
//   NetworkInfoImpl(this.connectionChecker);
//
//   @override
//   Future<bool> get isConnected => connectionChecker.hasConnection;
// }

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{
  @override
  Future<bool> get isConnected async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
