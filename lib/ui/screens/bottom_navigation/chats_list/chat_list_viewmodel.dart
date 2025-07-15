

import 'dart:developer';

import 'package:chat/core/enums/enums.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/core/others/base_viewModel.dart';
import 'package:chat/core/services/database_services.dart';

class ChatListViewmodel extends BaseViewmodel {
  final DatabaseServices _db;
  final UserModel _currentUser;

  ChatListViewmodel(this._db, this._currentUser) {
    fetchUsers();
  }

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  List<UserModel> get users => _users;
  List<UserModel> get filteredUsers => _filteredUsers;

  search(String value) {
    if (value.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users
          .where((e) => 
              e.name != null && 
              e.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  fetchUsers() async {
    try {
      setstate(ViewState.loading);
      _db.fetchUserStream(_currentUser.uid!).listen((data) {
        _users = data.docs.map((e) => UserModel.fromMap(e.data())).toList();
        
        // Sort users by last message timestamp if available
        _users.sort((a, b) {
          if (a.lastMessage == null && b.lastMessage == null) return 0;
          if (a.lastMessage == null) return 1;
          if (b.lastMessage == null) return -1;
          
          final aTime = a.lastMessage!["timeStamp"] as int;
          final bTime = b.lastMessage!["timeStamp"] as int;
          return bTime.compareTo(aTime); // Descending order (newest first)
        });
        
        _filteredUsers = _users;
        notifyListeners();
      });

      setstate(ViewState.idle);
    } catch (e) {
      setstate(ViewState.idle);
      log("Error Fetching Users: $e");
    }
  }
}
