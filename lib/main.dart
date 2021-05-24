import 'package:clean_neostore_login_app/features/user_login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:clean_neostore_login_app/injection_container.dart'as di;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/user_login/presentation/bloc/user_login_bloc.dart';
import 'injection_container.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home:LoginScreen());
  }
}


