import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';

abstract class UserLoginLocalDataSource{
  /// Gets the cached [UserLoginModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<void> cacheUserData(UserLoginModel userDataToCache);

  Future<UserLoginModel> getSharedPrefsData();
}