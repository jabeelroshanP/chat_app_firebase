
import 'dart:developer';
import 'dart:io';

import 'package:chat/core/enums/enums.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/core/others/base_viewModel.dart';
import 'package:chat/core/services/auth_services.dart';
import 'package:chat/core/services/database_services.dart';
import 'package:chat/core/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SignupViewmodel extends BaseViewmodel {
  final AuthServices _auth;
  final DatabaseServices _db;
  final StorageService _storage;

  SignupViewmodel(this._auth, this._db, this._storage);

  final _picker = ImagePicker();

  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  File? _image;

  File? get image => _image;

  pickimage() async {
    try {
      final pic = await _picker.pickImage(source: ImageSource.gallery);

      if (pic != null) {
        _image = File(pic.path);
        notifyListeners();
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  void setName(String value) {
    _name = value.trim();
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value.trim();
    notifyListeners();
  }

  setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  bool _validateInputs() {
    if (_name.isEmpty) {
      throw Exception("Please enter your name");
    }
    
    if (_email.isEmpty) {
      throw Exception("Please enter your email");
    }
    
    if (!_email.contains('@') || !_email.contains('.')) {
      throw Exception("Please enter a valid email");
    }
    
    if (_password.isEmpty) {
      throw Exception("Please enter a password");
    }
    
    if (_password.length < 6) {
      throw Exception("Password must be at least 6 characters");
    }
    
    if (_password != _confirmPassword) {
      throw Exception("Passwords do not match");
    }
    
    return true;
  }

  signup() async {
    setstate(ViewState.loading);
    try {
      _validateInputs();
      
      final res = await _auth.signup(_email, _password);

      if (res != null) {
        String? imageUrl;
        
        // Note: Image upload functionality is not being fixed as per request
        
        UserModel user = UserModel(
          uid: res.uid, 
          name: _name, 
          email: _email,
          imageUrl: imageUrl,
          unreadCounter: 0
        );

        await _db.saveUser(user.toMap());
      }

      setstate(ViewState.idle);
    } on FirebaseAuthException catch (e) {
      setstate(ViewState.idle);
      rethrow;
    } catch (e) {
      setstate(ViewState.idle);
      rethrow;
    }
  }
}