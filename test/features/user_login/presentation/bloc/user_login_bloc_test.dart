import 'package:clean_neostore_login_app/core/error/failures.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/usecases/get_login_access.dart';
import 'package:clean_neostore_login_app/features/user_login/presentation/bloc/user_login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

const SERVER_FAILURE_MESSAGE ='User login unsuccessful.';
const SERVER_FAILURE_USER_MESSAGE ='Email or password is wrong. try again';
const CACHE_FAILURE_MESSAGE ='Data missing..';
const CACHE_FAILURE_USER_MESSAGE ='Data missing..';

class MockGetLoginAccess extends Mock implements GetLoginAccess{}

void main(){
  UserLoginBloc userLoginBloc;
  MockGetLoginAccess mockGetLoginAccess;
  setUp((){
    mockGetLoginAccess=MockGetLoginAccess();
    userLoginBloc=UserLoginBloc(access: mockGetLoginAccess);
  });

  test('Initial state should be empty',(){
    //assert
    expect(userLoginBloc.initialState,Empty());
  });

  group('GetLoginAccess',(){
    final String tEmail='abc@gmail.com';
    final String tPassword='admin@123';
    final tUserDetails=UserLogin(status:200, message:'test login', userMsg:'test user login',
        data: UserData(firstName:'mandar',lastName: 'khandangale',email: 'abc@gmail.com',profilePic:null,gender: 'M',phoneNo: '1234567892',dob: '22/03/99',accessToken: '6034f93060f34'));

    test('should get data from the access usecase',()async{
      //arrange
      when(mockGetLoginAccess(any)).thenAnswer((_)async =>Right(tUserDetails));
      //act
      userLoginBloc.add(GetAccessForUserLogin(tEmail,tPassword));
      await untilCalled(mockGetLoginAccess(any));
      //assert
      verify(mockGetLoginAccess(Params(email:tEmail, password:tPassword)));
    });
    
    test('should emit [Loading,Loaded] when data is gotten successfully',()async{
      //arrange
      when(mockGetLoginAccess(any)).thenAnswer((_)async =>Right(tUserDetails));
      //assert later
      final expected=[
        Empty(),
        Loading(),
        Loaded(userLogin:tUserDetails),
      ];
      expectLater(userLoginBloc.asBroadcastStream(),emitsInOrder(expected));
      //act
      userLoginBloc.add(GetAccessForUserLogin(tEmail, tPassword));
    });

    test('should emit [Loading,Error] with a proper message for error when getting data fails',()async{
      //arrange
      when(mockGetLoginAccess(any)).thenAnswer((_)async =>Left(ServerFailure()));
      //assert later
      final expected=[
        Empty(),
        Loading(),
        Error(message:SERVER_FAILURE_MESSAGE,user_msg:SERVER_FAILURE_USER_MESSAGE),
      ];
      expectLater(userLoginBloc.asBroadcastStream(),emitsInOrder(expected));
      //act
      userLoginBloc.add(GetAccessForUserLogin(tEmail, tPassword));
    });

    test('should emit [Loading,Error] with a proper message for error when getting data fails',()async{
      //arrange
      when(mockGetLoginAccess(any)).thenAnswer((_)async =>Left(CacheFailure()));
      //assert later
      final expected=[
        Empty(),
        Loading(),
        Error(message:CACHE_FAILURE_MESSAGE,user_msg:CACHE_FAILURE_USER_MESSAGE),
      ];
      expectLater(userLoginBloc.asBroadcastStream(),emitsInOrder(expected));
      //act
      userLoginBloc.add(GetAccessForUserLogin(tEmail, tPassword));
    });
  });
}