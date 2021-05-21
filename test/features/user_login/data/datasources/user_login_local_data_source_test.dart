import 'dart:convert';

import 'package:clean_neostore_login_app/core/error/exceptions.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_local_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}

void main(){
  UserLoginLocalDataSourceImpl dataSourceImpl;
  MockSharedPreferences mockSharedPreferences;
  setUp((){
    mockSharedPreferences=MockSharedPreferences();
    dataSourceImpl=UserLoginLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getSharedPrefsData', (){
    final tUserLoginModel=UserLoginModel.fromJson(json.decode(fixture('response_cached.json')));
    test('Should return user login data when there is in Shared Preferences', ()async{
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('response_cached.json'));
      //act
      final result=await dataSourceImpl.getSharedPrefsData();
      //assert
      verify(mockSharedPreferences.getString(CACHED_LOGIN_DATA));
      expect(result,equals(tUserLoginModel));
    });

    test('Should return Cache Exception when there is no Cache Value', ()async{
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call=dataSourceImpl.getSharedPrefsData;
      //assert
      expect(()=>call(),throwsA(isInstanceOf<CacheException>()));
    });
  });
  
  group('cacheLoginData',(){
    final tUserLoginModel=UserLoginModel(status: 200,message:'User login is successful.',userMsg: 'Logged In successfully',
        dataModel:UserDataModel(firstName: 'Mandar',lastName: 'Khandagale',email:'mandarkhandagale08@gmail.com',profilePic: 'http://staging.php-dev.in:8844/trainingapp/uploads/prof_img/thumb/medium/605d8a714230a.jpg',
            gender:'M',phoneNo:'8692933498',accessToken:'6034f93060f34',dob:'08-10-1998'));

    test('Should call shared Preferences to cache the data',()async{
      //act
      dataSourceImpl.cacheUserData(tUserLoginModel);
      //assert
      final expectedJsonString=json.encode(tUserLoginModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_LOGIN_DATA,expectedJsonString));
    });
  });
}