

import 'package:connectivity_plus/connectivity_plus.dart';


abstract class NetworkInfo {
  Future<bool>? get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
   var connectivityResult = await connectivity.checkConnectivity();
   return connectivityResult != ConnectivityResult.none;

  }
}



// abstract class NetworkInfo {
//   Future<bool> get isConnected;
// }

// class NetworkInfoImpl implements NetworkInfo{
//   @override
//   Future<bool> get isConnected async {
//     var connectivityResult = await Connectivity().checkConnectivity();

//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
