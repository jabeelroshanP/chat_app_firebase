
import 'dart:async';

import 'package:chat/core/models/message_model.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/core/others/base_viewModel.dart';
import 'package:chat/core/services/chat_services.dart';
import 'package:flutter/material.dart';

class ChatViewmodel extends BaseViewmodel {
  final ChatServices _chatServices;
  final UserModel _currentUser;
  final UserModel _receiver;

  StreamSubscription? _subscription;
  ChatViewmodel(this._chatServices, this._currentUser, this._receiver) {
    getChatRoom();
    
    // Reset unread counter when opening chat
    _chatServices.resetUnreadCounter(_currentUser.uid!);

    _subscription = _chatServices.getMessages(chatRoomId).listen((messages) {
      _messages = messages.docs.map((e) => MessageModel.fromMap(e.data())).toList();
      notifyListeners();
    });
  }

  String chatRoomId = "";

  final _messageController = TextEditingController();

  TextEditingController get controller => _messageController;

  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  getChatRoom() {
    if (_currentUser.uid.hashCode > _receiver.uid.hashCode) {
      chatRoomId = "${_currentUser.uid}_${_receiver.uid}";
    } else {
      chatRoomId = "${_receiver.uid}_${_currentUser.uid}";
    }
  }

  saveMessage() async {
    if (_messageController.text.trim().isEmpty) {
      throw Exception("Message cannot be empty");
    }
    
    try {
      final now = DateTime.now();

      final message = MessageModel(
        id: now.millisecondsSinceEpoch.toString(),
        content: _messageController.text.trim(),
        senderId: _currentUser.uid,
        receiverId: _receiver.uid,
        timeStamp: now,
      );
      
      await _chatServices.saveMessage(message.toMap(), chatRoomId);

      await _chatServices.updateLastMessage(
        _currentUser.uid!,
        _receiver.uid!,
        message.content!,
        now.millisecondsSinceEpoch,
      );

      _messageController.clear();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _messageController.dispose();
  }
}
