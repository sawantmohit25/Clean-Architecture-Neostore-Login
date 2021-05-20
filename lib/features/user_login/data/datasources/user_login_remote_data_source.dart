import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';

abstract class UserLoginRemoteDataSource{
  /// Calls the http://staging.php-dev.in:8844/trainingapp/api/users/login endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserLoginModel>getLoginAccess(String email,String password);
}