import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/core/errors/expentions.dart';

class GroupLocalDataSource {
  final CacheHelper cache;
  //final String key ='' ;
  GroupLocalDataSource({required this.cache});

  cacheGroup({required String key,required var userToCache}) {
    if (userToCache != null) {
      cache.saveData(
        key: key,
        value: userToCache
      );
    } else {
      throw CacheException(errorMessage: "No Internet Connection");
    }
  }
  getGroupCache({required String key}) {
    cache.getData(
        key: key,
      );
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


