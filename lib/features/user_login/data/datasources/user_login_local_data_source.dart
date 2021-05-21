import 'dart:convert';

import 'package:clean_neostore_login_app/core/error/exceptions.dart';
import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class UserLoginLocalDataSource{
  /// Gets the cached [UserLoginModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<UserLoginModel> getSharedPrefsData();

  Future<void> cacheUserData(UserLoginModel userDataToCache);

}

const CACHED_LOGIN_DATA='CACHED_LOGIN_DATA';

class UserLoginLocalDataSourceImpl implements UserLoginLocalDataSource{
  final SharedPreferences sharedPreferences;

  UserLoginLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<UserLoginModel> getSharedPrefsData() {
    final jsonString=sharedPreferences.getString(CACHED_LOGIN_DATA);
    if(jsonString!=null){
      return Future.value(UserLoginModel.fromJson(json.decode(jsonString)));
    }
    else{
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUserData(UserLoginModel userDataToCache) {
    return sharedPreferences.setString(CACHED_LOGIN_DATA,json.encode(userDataToCache.toJson()));
  }

}