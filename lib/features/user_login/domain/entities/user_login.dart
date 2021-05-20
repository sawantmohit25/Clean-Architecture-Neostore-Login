import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
class UserLogin extends Equatable{
  final int status;
  final UserData data;
  final String message;
  final String userMsg;

  UserLogin({@required this.status,@required this.data,@required this.message,@required this.userMsg});
}

class UserData extends Equatable{
  final String firstName;
  final String lastName;
  final String email;
  final String profilePic;
  final String gender;
  final String phoneNo;
  final String dob;
  final String accessToken;

  UserData({@required this.firstName,@required this.lastName,@required this.email,@required this.profilePic,@required this.gender,@required this.phoneNo,@required this.dob,@required this.accessToken});

}