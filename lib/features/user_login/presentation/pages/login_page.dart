import 'package:clean_neostore_login_app/features/user_login/domain/usecases/get_login_access.dart';
import 'package:clean_neostore_login_app/features/user_login/presentation/bloc/user_login_bloc.dart';
import 'package:clean_neostore_login_app/features/user_login/presentation/pages/home_page.dart';
import 'package:clean_neostore_login_app/features/user_login/presentation/widgets/loading_widget.dart';
import 'package:clean_neostore_login_app/features/user_login/presentation/widgets/message_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../injection_container.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  Color myHexColor1 = Color(0xfffe3f3f);
  Color myHexColor = Color(0xffe91c1a);
  final _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  UserLoginBloc _bloc;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    userName.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    _bloc=sl<UserLoginBloc>();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:myHexColor1,
      body:_buildBody(),
    );
  }
 Widget _buildBody() {
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocListener(
        bloc:_bloc,
        listener: (context, state) {
          if (state is Error) {
            Fluttertoast.showToast(
                msg:state.user_msg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                textColor: Colors.red
            );
          } else if (state is Loaded) {
            Fluttertoast.showToast(
                msg:state.userLogin.userMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                textColor: Colors.red
            );
            Navigator.push(context,MaterialPageRoute(builder:(context)=>HomePage(userLogin:state.userLogin,)));
          }
        },
        child: BlocBuilder<UserLoginBloc,UserLoginState>(
          builder: (BuildContext context, state) {
            if (state is Empty) {
              return _buildForm();
            } else if (state is Loading) {
              return LoadingWidget();
            } else {
              return _buildForm();
            }
          },
        ),
      ),
    );
  }
  Widget _buildForm(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding:EdgeInsets.fromLTRB(33.0,0,33.0,0),
              child: Container(
                child:Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25,150,25,0),
                        child: Text('NeoSTORE', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.white,
                            fontSize: 45.0),),
                      ),
                      SizedBox(height: 49.0),
                      TextFormField(decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 0.0),),
                        border: OutlineInputBorder(),
                        hintText:'Username',
                        errorStyle: TextStyle(color: Colors.white),
                        errorBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0),) ,
                        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0),),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0),),
                        contentPadding: EdgeInsets.symmetric(vertical: 18.0,horizontal: 5.0),
                        hintStyle:TextStyle(color:Colors.white),
                        prefixIcon:Icon(Icons.person,color:Colors.white),
                      ),
                        controller: userName,
                        validator:validateUserName,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                      SizedBox(height: 13.0),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                          errorStyle: TextStyle(color: Colors.white),
                          errorBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0),) ,
                          focusedErrorBorder:OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0),),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0),),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 5.0),
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),),
                        controller: password,
                        validator: validatePass,
                        obscureText:true,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                      SizedBox(height: 33.0),
                      Container(
                        height: 47.0,
                        width: 293.0,
                        child: RaisedButton(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                          onPressed: ()async{
                            if(_formKey.currentState.validate()) {
                              final String email=userName.text;
                              final String pass=password.text;
                              dispatchValues(email,pass);
                              print('hi');
                              // BlocListener<UserLoginBloc, UserLoginState>(
                              //   listener: (context, state) {
                              //     if (state is Empty) {
                              //       print('empty');
                              //       return Text('Empty State');
                              //     } else if (state is Loading) {
                              //       print('loading');
                              //       return LoadingWidget();
                              //     } else if (state is Loaded) {
                              //       print('loaded');
                              //       Fluttertoast.showToast(
                              //           msg:state.userLogin.userMsg,
                              //           toastLength: Toast.LENGTH_SHORT,
                              //           gravity: ToastGravity.BOTTOM,
                              //           backgroundColor: Colors.white,
                              //           textColor: Colors.red
                              //       );
                              //       Navigator.push(context,MaterialPageRoute(builder:(context)=>HomePage()));
                              //     } else if (state is Error) {
                              //       print('error');
                              //       Fluttertoast.showToast(
                              //           msg:state.user_msg,
                              //           toastLength: Toast.LENGTH_SHORT,
                              //           gravity: ToastGravity.BOTTOM,
                              //           backgroundColor: Colors.white,
                              //           textColor: Colors.red
                              //       );
                              //     }
                              //   },
                              // );
                            }
                          },
                          color: Colors.white,
                          textColor: Colors.red,
                          splashColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(color: Colors.red)),
                        ),
                      ),
                      SizedBox(height: 21.0),
                      RichText(
                        text: TextSpan(
                            style:TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0) ,
                            text: 'Forgot Password?',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => ForgotPassword()));
                              }

                        ),
                      )
                    ],
                  ),
                ) ,
              )
          ),
          SizedBox(height: 160.0,),
          Padding(
            padding: const EdgeInsets.fromLTRB(13.0,0,13.0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0) ,
                    text: 'DONT HAVE AN ACCOUNT?',
                  ),
                ),
                Container(
                  width:46 ,
                  height:46 ,
                  color:myHexColor,
                  child: IconButton(icon:Icon(Icons.add,size:32,),color:Colors.white, onPressed:(){
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => RegisterScreen()));

                  }),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
  String validateUserName(val) {
    if (val.isEmpty) {
      return 'Required';
    }
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val)) {
      return 'Please Enter a valid UserName';
    }
    return null;
  }
  String validatePass(val) {
    if (val.isEmpty) {
      return 'Required';
    }
    else if(val.toString().length<6) // Can be used Regex for extra validation Minimum 1 uppercase,lowercase,1 numeric number,1 special character,allow common char RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
        {
      return 'Password should be minimum of 6 characters';
    }
    else{
      return null;
    }
  }

  void dispatchValues(String email, String pass) {
    _bloc.add(GetAccessForUserLogin(email, pass));
  }
}
