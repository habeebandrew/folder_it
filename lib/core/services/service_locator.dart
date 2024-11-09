

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:folder_it/features/User/data/datasources/user_local_data_source.dart';
import 'package:folder_it/features/User/data/datasources/user_remote_data_source.dart';
import 'package:folder_it/core/connection/network_info.dart';
import 'package:folder_it/core/databases/api/http_consumer.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:get_it/get_it.dart';


  final getIt = GetIt.instance;

  void setupServiceLocator() {
    getIt.registerSingleton<CacheHelper>(CacheHelper());
    getIt.registerSingleton<HttpConsumer>(HttpConsumer());

    getIt.registerSingleton<UserRemoteDataSource>(UserRemoteDataSource(api:getIt<HttpConsumer>()));
    getIt.registerSingleton<UserLocalDataSource>(UserLocalDataSource(cache:getIt<CacheHelper>() ));

    getIt.registerSingleton<Connectivity>(Connectivity());
    getIt.registerSingleton<NetworkInfoImpl>(NetworkInfoImpl(connectivity:  getIt<Connectivity>()));
  }
  