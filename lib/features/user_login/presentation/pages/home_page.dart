import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:clean_neostore_login_app/features/user_login/presentation/bloc/user_login_bloc.dart';
import 'package:clean_neostore_login_app/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  final UserLogin userLogin;

  const HomePage({Key key, @required this.userLogin}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color myHexColor1 = Color(0xfffe3f3f);
  Color myHexColor = Color(0xffe91c1a);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Page'),
        backgroundColor: myHexColor,
        actions:<Widget> [
          FlatButton.icon(icon:Icon(Icons.person,color: Colors.white,), label:Text('Logout',style: TextStyle(color: Colors.white),),onPressed: (){
            Fluttertoast.showToast(
                msg:'Logged Out Sucessfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                textColor: Colors.red
            );
            Navigator.pop(context);
          },)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Text('User Details:-',style:TextStyle(decoration:TextDecoration.underline,fontSize:40,fontWeight:FontWeight.bold,),),
                      ],
                    ),
                    SizedBox(height:20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(image: NetworkImage(widget.userLogin.data.profilePic),
                                fit: BoxFit.fill),),
                        ),
                      ],
                    ),
                    SizedBox(height:20.0),
                    Text('Name:-',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold),),
                    SizedBox(height:10.0),
                    Text('${widget.userLogin.data.firstName} ${widget.userLogin.data.lastName}',style:TextStyle(fontSize:20),),
                    SizedBox(height:20.0),
                    Text('Email:-',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold),),
                    SizedBox(height:10.0),
                    Text(widget.userLogin.data.email,style:TextStyle(fontSize:20),),
                    SizedBox(height:20.0),
                    Text('PhoneNo:-',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold),),
                    SizedBox(height:10.0),
                    Text(widget.userLogin.data.phoneNo,style:TextStyle(fontSize:20),),
                    SizedBox(height:20.0),
                    Text('Gender:-',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold),),
                    SizedBox(height:10.0),
                    Text(widget.userLogin.data.gender,style:TextStyle(fontSize:20),),
                    SizedBox(height:20.0),
                    Text('Date Of Birth:-',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold),),
                    SizedBox(height:10.0),
                    Text(widget.userLogin.data.dob,style:TextStyle(fontSize:20),),
                    SizedBox(height:20.0),
                  ],
                ),
        ),
      ),
    );
  }
}
