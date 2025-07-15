import 'dart:convert';

class MessageModel {
  final String? id;
  final String? content;
  final String? senderId;
  final String? receiverId;
  final DateTime? timeStamp;

  MessageModel({
    this.id,
    this.content,
    this.senderId,
    this.receiverId,
    this.timeStamp,
  });



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamp': timeStamp?.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] != null ? map['id'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      receiverId: map['receiverId'] != null ? map['receiverId'] as String : null,
      timeStamp: map['timeStamp'] != null ? DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
