import 'dart:developer';

import 'package:chat/core/enums/enums.dart';
import 'package:chat/core/others/base_viewModel.dart';
import 'package:chat/core/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginscreenViewmodel extends BaseViewmodel{
  final AuthServices _auth;

  LoginscreenViewmodel(this._auth);
  
  String _email = "";
  String _password = "";

 void setEmail(String value){
    _email=value;
    notifyListeners();

    log("email: $_email");
  }

  
  setPassword(String value){
    _password=value;
    notifyListeners();

    log("Password: $_password");
  }
   
  login()async{
    setstate(ViewState.loading);
    try {
     await _auth.login(_email, _password);
     setstate(ViewState.idle);
    } 
    on FirebaseAuthException catch(e){
           setstate(ViewState.idle);

      rethrow;
    }
    catch (e) {
      log(e.toString());
           setstate(ViewState.idle);

      rethrow;
    }
  }
}