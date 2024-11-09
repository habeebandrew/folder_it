import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/core/errors/expentions.dart';

class UserLocalDataSource {
  final CacheHelper cache;
  final String key ='' ;
  UserLocalDataSource({required this.cache});

  cacheUser({required var userToCache,required String key}) {
    if (userToCache != null) {
      cache.saveData(
        key: key,
        value: userToCache
      );
    } else {
      throw CacheException(errorMessage: "No Internet Connection");
    }
  }

  // Future<UserModel> getLastUser() {
  //   final jsonString = cache.getDataString(key: key);

  //   if (jsonString != null) {
  //     return Future.value(UserModel.fromJson(json.decode(jsonString)));
  //   } else {
  //     throw CacheException(errorMessage: "No Internet Connection");
  //   }
  // }
}

