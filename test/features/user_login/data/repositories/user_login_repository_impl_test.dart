import 'package:clean_neostore_login_app/core/error/exceptions.dart';
import 'package:clean_neostore_login_app/core/error/failures.dart';
import 'package:clean_neostore_login_app/core/platform/network_info.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_local_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_remote_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/data/models/user_login_model.dart';
import 'package:clean_neostore_login_app/features/user_login/data/repositories/user_login_repository_impl.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

class MockRemoteDataSource extends Mock implements UserLoginRemoteDataSource{}

class MockLocalDataSource extends Mock implements UserLoginLocalDataSource{}

class MockNetworkInfo extends Mock implements NetworkInfo{}

void main(){
  UserLoginRepositoryImpl userLoginRepositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  setUp((){
    mockRemoteDataSource=MockRemoteDataSource();
    mockLocalDataSource=MockLocalDataSource();
    mockNetworkInfo=MockNetworkInfo();
    userLoginRepositoryImpl=UserLoginRepositoryImpl(remoteDataSource:mockRemoteDataSource,localDataSource:mockLocalDataSource,networkInfo:mockNetworkInfo);
  });

  void runTestOnline(Function body){
    group('device is online',(){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_)async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body){
    group('device is online',(){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_)async => false);
      });
      body();
    });
  }

  group('getUserLoginAccess',(){

    final String tEmail='abc@gmail.com';
    final String tPassword='admin@123';
    final tUserLoginModel=UserLoginModel(status: 200,message:'User login is successful.',userMsg: 'Logged In successfully',
        dataModel:UserDataModel(firstName: 'Mandar',lastName: 'Khandagale',email:'mandarkhandagale08@gmail.com',profilePic: 'http://staging.php-dev.in:8844/trainingapp/uploads/prof_img/thumb/medium/605d8a714230a.jpg',
            gender:'M',phoneNo:'8692933498',accessToken:'6034f93060f34',dob:'08-10-1998'));
    final UserLogin tUserLogin=tUserLoginModel;

    test('should check if the device is online',()async{
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async => true);
      //act
      userLoginRepositoryImpl.getLoginAccess(tEmail,tPassword);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline((){
      test('should return remote data when the call to remote data is successful',()async{
        //arrange
        when(mockRemoteDataSource.getLoginAccess(any, any)).thenAnswer((_)async =>tUserLoginModel);
        //act
        final result=await userLoginRepositoryImpl.getLoginAccess(tEmail, tPassword);
        //assert
        verify(mockRemoteDataSource.getLoginAccess(tEmail, tPassword));
        expect(result,equals(Right(tUserLogin)));
      });

      test('should cache the data locally when the call to remote data is successful',()async{
        //arrange
        when(mockRemoteDataSource.getLoginAccess(any, any)).thenAnswer((_)async =>tUserLoginModel);
        //act
        await userLoginRepositoryImpl.getLoginAccess(tEmail, tPassword);
        //assert
        verify(mockRemoteDataSource.getLoginAccess(tEmail, tPassword));
        verify(mockLocalDataSource.cacheUserData(tUserLoginModel));
      });

      test('should return server failure when the call to remote data is unsuccessful',()async{
        //arrange
        when(mockRemoteDataSource.getLoginAccess(any, any)).thenThrow(ServerException());
        //act
        final result=await userLoginRepositoryImpl.getLoginAccess(tEmail, tPassword);
        //assert
        verify(mockRemoteDataSource.getLoginAccess(tEmail, tPassword));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result,equals(Left(ServerFailure())));
      });
    });

    runTestOffline((){
      test('should return sharedPrefs local cached data when the cached data is present',()async{
        //arrange
        when(mockLocalDataSource.getSharedPrefsData()).thenAnswer((_)async =>tUserLoginModel);
        //act
        final result=await userLoginRepositoryImpl.getLoginAccess(tEmail, tPassword);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getSharedPrefsData());
        expect(result,equals(Right(tUserLogin)));
      });

      test('should return CacheFailure  when there is no cached data present',()async{
        //arrange
        when(mockLocalDataSource.getSharedPrefsData()).thenThrow(CacheException());
        //act
        final result=await userLoginRepositoryImpl.getLoginAccess(tEmail, tPassword);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getSharedPrefsData());
        expect(result,equals(Left(CacheFailure())));
      });

    });
  });
}