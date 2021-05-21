import 'dart:convert';

import 'package:clean_neostore_login_app/core/error/exceptions.dart';
import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';
import 'package:http/http.dart'as http;
import 'package:meta/meta.dart';

abstract class UserLoginRemoteDataSource{
  /// Calls the http://staging.php-dev.in:8844/trainingapp/api/users/login endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserLoginModel>getLoginAccess(String email,String password);
}

class UserLoginRemoteDataSourceImpl implements UserLoginRemoteDataSource{
  final http.Client client;

  UserLoginRemoteDataSourceImpl({@required this.client});
  @override
  Future<UserLoginModel> getLoginAccess(String email, String password) async{
    final response =await client.post('http://staging.php-dev.in:8844/trainingapp/api/users/login',body:{"email": email, "password":password,},);
    if(response.statusCode==200){
      return UserLoginModel.fromJson(json.decode(response.body));
    }
    else{
      throw ServerException();
    }
  }

}