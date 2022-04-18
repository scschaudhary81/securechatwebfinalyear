import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { TEXT, IMAGE, UNKNOWN }

class ChatMessage {
  final String senderId;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({
    required this.senderId,
    required this.content,
    required this.sentTime,
    required this.type,
  });
  factory ChatMessage.fromJSON(Map<String,dynamic>_json)
  {
    MessageType _messageType;
    switch(_json['type'])
    {
      case "text" :
        _messageType = MessageType.TEXT;
        break;
      case "image":
        _messageType  = MessageType.IMAGE;
        break;
      default:
        _messageType = MessageType.UNKNOWN;
    }
    return ChatMessage(senderId: _json['sender_id'], content: _json['content'], sentTime: _json['sent_time'].toDate(), type: _messageType);
  }

  Map<String,dynamic>jsonChatMessage()
  {
    String _messageType;
    switch(type)
    {
      case MessageType.IMAGE:
        _messageType = "image";
        break;
      case MessageType.TEXT:
        _messageType = "text";
        break;
      default:
        _messageType = "";
    }
    return {
      "content":content,
      "type":_messageType,
      "sender_id":senderId,
      "sent_time":sentTime,
    };
  }
}
