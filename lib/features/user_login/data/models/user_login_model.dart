import 'package:clean_neostore_login_app/features/user_login/domain/entities/user_login.dart';
import 'package:meta/meta.dart';

class UserLoginModel extends UserLogin{
  int status;
  UserDataModel dataModel;
  String message;
  String userMsg;
  UserLoginModel({@required this.status,@required this.dataModel,@required  this.message,@required this.userMsg}):super(status: status,data:dataModel,message: message,userMsg: userMsg);
  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
    status:json['status'],
    dataModel :json['data'] != null ? new UserDataModel.fromJson(json['data']) : null,
    message : json['message'],
    userMsg : json['user_msg'],);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dataModel!= null) {
      data['data'] =this.dataModel.toJson();
    }
    data['message'] = this.message;
    data['user_msg'] = this.userMsg;
    return data;
  }

}


class UserDataModel extends UserData{
   String firstName;
   String lastName;
   String email;
   String profilePic;
   String gender;
   String phoneNo;
   String dob;
   String accessToken;

  UserDataModel({ this.firstName, this.lastName, this.email, this.profilePic, this.gender, this.phoneNo, this.dob, this.accessToken}):super(firstName:firstName,lastName:lastName,email:email,profilePic:profilePic,gender:gender,phoneNo:phoneNo,dob:dob,accessToken:accessToken);

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
    firstName :json['first_name'],
    lastName :json['last_name'],
    email :json['email'],
    profilePic : json['profile_pic'],
    gender:json['gender'],
    phoneNo : json['phone_no'],
    dob : json['dob'],
    accessToken : json['access_token'],);
  }

   Map<String, dynamic>  toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['first_name'] = this.firstName;
     data['last_name'] = this.lastName;
     data['email'] = this.email;
     data['profile_pic'] = this.profilePic;
     data['gender'] = this.gender;
     data['phone_no'] = this.phoneNo;
     data['dob'] = this.dob;
     data['access_token'] = this.accessToken;
     return data;
   }

  // Map<String, dynamic> toJson() {
  //   // final Map<String, dynamic> data = new Map<String, dynamic>();
  //   return {
  //     'first_name': this.firstName,
  //     'last_name': this.lastName,
  //     'email': this.email,
  //     'profile_pic': this.profilePic,
  //     'gender': this.gender,
  //     'phone_no': this.phoneNo,
  //     'dob': this.dob,
  //     'access_token': this.accessToken,
  //   };
  // }


}

