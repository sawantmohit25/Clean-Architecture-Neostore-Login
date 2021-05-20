import 'dart:convert';

import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
void main(){
  final tUserLoginModel=UserLoginModel(status: 200,message:'User login is successful.',userMsg: 'Logged In successfully',
      dataModel:UserDataModel(firstName: 'Mandar',lastName: 'Khandagale',email:'mandarkhandagale08@gmail.com',profilePic: 'http://staging.php-dev.in:8844/trainingapp/uploads/prof_img/thumb/medium/605d8a714230a.jpg',
          gender:'M',phoneNo:'8692933498',accessToken:'6034f93060f34',dob:'08-10-1998'));

  test('should be a subclass of UserLogin entity',()async{
    //assert
    expect(tUserLoginModel,isA<UserLogin>());
  });
  
  group('fromJson',(){
    test('should return a valid model ',()async{
      //arrange
      final Map<String,dynamic> jsonMap=json.decode(fixture('login_response.json'));
      print('mandar${jsonMap}');
      //act
      final result=UserLoginModel.fromJson(jsonMap);
      print('mohit${result.toJson()}');

      // assert
      expect(result,tUserLoginModel);
    });
  });

  group('toJson', (){
    test('should return a json Map containing a proper data',()async{
      //act
      final result=tUserLoginModel.toJson();
      //assert
      final expectedMap={
        "status": 200,
        "data": {
          "first_name": "Mandar",
          "last_name": "Khandagale",
          "email": "mandarkhandagale08@gmail.com",
          "profile_pic": "http://staging.php-dev.in:8844/trainingapp/uploads/prof_img/thumb/medium/605d8a714230a.jpg",
          "gender": "M",
          "phone_no": "8692933498",
          "dob": "08-10-1998",
          "access_token": "6034f93060f34"
        },
        "message": "User login is successful.",
        "user_msg": "Logged In successfully"
      };
      expect(result,expectedMap);
    });
  });
}