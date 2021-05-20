import 'package:clean_neostore_login_app/core/error/failures.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:dartz/dartz.dart';

abstract class Usecase<Type,Params>{
  Future<Either<Failure,UserLogin>> call(Params params);
}