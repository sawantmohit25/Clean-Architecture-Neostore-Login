import 'dart:convert';

import 'package:clean_neostore_login_app/core/error/exceptions.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_remote_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart'as http;
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client{}

void main(){
  UserLoginRemoteDataSourceImpl remoteDataSourecImpl;
  MockHttpClient mockHttpClient;
  setUp((){
    mockHttpClient=MockHttpClient();
    remoteDataSourecImpl=UserLoginRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setupMockHttpClientSuccess200(){
    when(mockHttpClient.post(any,body:anyNamed('body'))).thenAnswer((_)async =>http.Response(fixture('login_response.json'),200));
  }

  void setupMockHttpClientFailure404(){
    when(mockHttpClient.post(any,body:anyNamed('body'))).thenAnswer((_)async =>http.Response('Something went wrong',404));
  }

  group('getLoginAccess', (){
    final String tEmail='abc@gmail.com';
    final String tPassword='admin@123';
    final tUserLoginModel=UserLoginModel.fromJson(json.decode(fixture('login_response.json')));

    test('should perform a POST request on url ', ()async{
      //arrange
      setupMockHttpClientSuccess200();
      //act
      remoteDataSourecImpl.getLoginAccess(tEmail, tPassword);
      //assert
      verify(mockHttpClient.post('http://staging.php-dev.in:8844/trainingapp/api/users/login',body:{
        "email": tEmail,
        "password":tPassword,
      },));
    });

    test('should return UserData when the response code is 200 ', ()async{
      //arrange
      setupMockHttpClientSuccess200();
      //act
      final result=await remoteDataSourecImpl.getLoginAccess(tEmail, tPassword);
      //assert
      expect(result,equals(tUserLoginModel));
    });

    test('should throw a ServerException when the response code is 404 or other ', ()async{
      //arrange
      setupMockHttpClientFailure404();
      //act
      final call=remoteDataSourecImpl.getLoginAccess;
      //assert
      expect(()=>call(tEmail,tPassword),throwsA(isInstanceOf<ServerException>()));
    });
  });

}
