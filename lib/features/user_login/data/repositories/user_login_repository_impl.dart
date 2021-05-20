import 'package:clean_neostore_login_app/core/error/exceptions.dart';
import 'package:clean_neostore_login_app/core/error/failures.dart';
import 'package:clean_neostore_login_app/core/platform/network_info.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_local_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_remote_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/repositories/user_login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class UserLoginRepositoryImpl extends UserLoginRepository{
  final UserLoginRemoteDataSource remoteDataSource;
  final UserLoginLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserLoginRepositoryImpl({@required this.remoteDataSource,@required this.localDataSource,@required this.networkInfo});
  @override
  Future<Either<Failure, UserLogin>> getLoginAccess(String email, String password) async{
    if(await networkInfo.isConnected){
      try{
        final remoteData=await remoteDataSource.getLoginAccess(email, password);
        localDataSource.cacheUserData(remoteData);
        return Right(remoteData);
      }
      on ServerException{
        return Left(ServerFailure());
      }
    }
    else{
      try{
        final localData= await localDataSource.getSharedPrefsData();
        return Right(localData);
      }
      on CacheException{
        return Left(CacheFailure());
      }

    }
  }

}