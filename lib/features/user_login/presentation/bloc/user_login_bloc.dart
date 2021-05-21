import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_neostore_login_app/core/error/failures.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/usecases/get_login_access.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'user_login_event.dart';
part 'user_login_state.dart';

const SERVER_FAILURE_MESSAGE ='User login unsuccessful.';
const SERVER_FAILURE_USER_MESSAGE ='Email or password is wrong. try again';
const CACHE_FAILURE_MESSAGE ='Data missing..';
const CACHE_FAILURE_USER_MESSAGE ='Data missing..';


class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  final GetLoginAccess getLoginAccess;

  UserLoginBloc({@required GetLoginAccess access}):assert(access!=null),getLoginAccess=access;

  @override
  UserLoginState get initialState => Empty();

  @override
  Stream<UserLoginState> mapEventToState(
    UserLoginEvent event,
  ) async* {
    if(event is GetAccessForUserLogin){
      yield Loading();
      final failureOrUserData=await getLoginAccess.call(Params(email:event.email,password:event.password));
      yield failureOrUserData.fold((failure) => Error(message:_mapFailureToMessage(failure), user_msg: _mapFailureToUserMessage(failure)), (userData) =>Loaded(userLogin: userData));
    }
  }

  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }

  String _mapFailureToUserMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_USER_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_USER_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }



}
