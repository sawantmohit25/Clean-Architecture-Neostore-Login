part of 'user_login_bloc.dart';
@immutable
abstract class UserLoginEvent extends Equatable {
  UserLoginEvent([List props=const <dynamic>[]]):super(props);
}

class GetAccessForUserLogin extends UserLoginEvent{
  final String email;
  final String password;

  GetAccessForUserLogin(this.email, this.password):super([email,password]);
}