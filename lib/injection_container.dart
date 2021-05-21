import 'package:clean_neostore_login_app/core/network/network_info.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_local_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/data/datasources/user_login_remote_data_source.dart';
import 'package:clean_neostore_login_app/features/user_login/data/repositories/user_login_repository_impl.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/repositories/user_login_repository.dart';
import 'package:clean_neostore_login_app/features/user_login/domain/usecases/get_login_access.dart';
import 'package:clean_neostore_login_app/features/user_login/presentation/bloc/user_login_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


final sl=GetIt.instance;

Future<void> init()async{
  //! Features -Number Trivia
  //Bloc
  sl.registerFactory(() =>UserLoginBloc(access: sl()));
  
  //Usecases
  sl.registerLazySingleton(() => GetLoginAccess(sl()));
  
  //Repository
  sl.registerLazySingleton<UserLoginRepository>(() =>UserLoginRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  //Data Sources
  
  sl.registerLazySingleton<UserLoginRemoteDataSource>(() =>UserLoginRemoteDataSourceImpl(client:sl()));

  sl.registerLazySingleton<UserLoginLocalDataSource>(() =>UserLoginLocalDataSourceImpl(sharedPreferences:sl()));

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() =>NetworkInfoImpl(sl()));

  //!External
  final sharedPreferences =await SharedPreferences.getInstance();
  sl.registerLazySingleton(() =>sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

}