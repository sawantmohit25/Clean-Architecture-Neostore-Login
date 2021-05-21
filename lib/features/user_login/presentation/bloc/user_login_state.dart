part of 'user_login_bloc.dart';
@immutable
abstract class UserLoginState extends Equatable {
  UserLoginState([List props =const<dynamic>[]]):super(props);
}

class Empty extends UserLoginState{}

class Loading extends UserLoginState{}

class Loaded extends UserLoginState{
  final UserLogin userLogin;

  Loaded({@required this.userLogin}):super([userLogin]);
}

class Error extends UserLoginState{
  final String message;
  final String user_msg;

  Error({@required this.message,@required this.user_msg}):super([message,user_msg]);
}