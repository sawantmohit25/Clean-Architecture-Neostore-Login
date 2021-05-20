import 'package:clean_neostore_login_app/core/error/failures.dart';
import 'package:clean_neostore_login_app/core/usecases/usecase.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/repositories/user_login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetLoginAccess implements Usecase<UserLogin,Params>{
  final UserLoginRepository userLoginRepository;

  GetLoginAccess(this.userLoginRepository);

  @override
  Future<Either<Failure,UserLogin>>call(Params params)async{
    return await userLoginRepository.getLoginAccess(params.email, params.password);
  }
}

class Params extends Equatable{
  final String email;
  final String password;
  Params({@required this.email,@required this.password}):super([email,password]);
}