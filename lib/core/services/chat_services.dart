


import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  final _fire = FirebaseFirestore.instance;

  saveMessage(Map<String, dynamic> message, String chatRoomId) async {
    try {
      await _fire
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection("messages")
          .add(message);
    } catch (e) {
      rethrow;
    }
  }

  updateLastMessage(
    String senderUid,
    String receiverUid,
    String message,
    int timeStamp,
  ) async {
    try {
      // Update sender's data - no unread counter increment for own messages
      await _fire.collection("users").doc(senderUid).update({
        'lastMessage': {
          "content": message,
          "timeStamp": timeStamp,
          "senderId": senderUid,
        },
      });

      // Update receiver's data - increment unread counter
      await _fire.collection("users").doc(receiverUid).update({
        'lastMessage': {
          "content": message,
          "timeStamp": timeStamp,
          "senderId": senderUid,
        },
        "unreadCounter": FieldValue.increment(1)
      });
    } catch (e) {
      rethrow;
    }
  }

  // Reset unread counter when opening a chat
  Future<void> resetUnreadCounter(String currentUserUid) async {
    try {
      await _fire.collection("users").doc(currentUserUid).update({
        "unreadCounter": 0
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return _fire
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }
}
