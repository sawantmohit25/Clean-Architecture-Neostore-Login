import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/repositories/user_login_repository.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/usecases/get_login_access.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserLoginRepository extends Mock implements UserLoginRepository{}

  void main(){
    GetLoginAccess usecase;
    MockUserLoginRepository mockUserLoginRepository;

    setUp((){
      mockUserLoginRepository=MockUserLoginRepository();
      usecase=GetLoginAccess(mockUserLoginRepository);
    });

    final String tEmail='abc@gmail.com';
    final String tPassword='admin@123';
    final tUserDetails=UserLogin(status:200, message:'test login', userMsg:'test user login',
        data: UserData(firstName:'mandar',lastName: 'khandangale',email: 'abc@gmail.com',profilePic:null,gender: 'M',phoneNo: '1234567892',dob: '22/03/99',accessToken: '6034f93060f34'));
    
    test('should get login response from the repository',()async{
      //arrange
      when(mockUserLoginRepository.getLoginAccess(any, any)).thenAnswer((_)async =>Right(tUserDetails));
      //act
      final result=await usecase(Params(email:tEmail,password:tPassword));
      //assert
      expect(result,Right(tUserDetails));
      verify(mockUserLoginRepository.getLoginAccess(tEmail, tPassword));
    });
  }
