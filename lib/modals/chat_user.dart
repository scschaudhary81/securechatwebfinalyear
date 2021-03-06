class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  late DateTime lastSeen;

  ChatUser({
    required this.name,
    required this.email,
    required this.imageURL,
    required this.lastSeen,
    required this.uid,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> _json) {
    return ChatUser(
      uid: _json["uid"],
      name: _json["name"],
      email: _json["email"],
      imageURL: _json["image"],
      lastSeen: _json["last_active"].toDate()
    );
  }
  Map<String,dynamic> toMap()
  {
    return {
      "email":email,
      "name":name,
      "last_active":lastSeen,
      "image":imageURL,
    };
  }
  String lastDayActive()
  {
    return "${lastSeen.month}/${lastSeen.day}/${lastSeen.year}";
  }
  String lastMinuteActive(){
    return "${-1*lastSeen.difference(DateTime.now()).inMinutes} minutes ago";
  }
  String lastHrsActive(){
    return "${-1*lastSeen.difference(DateTime.now()).inHours} hr ago";
  }
  bool wasRecentlyActive()
  {
    return DateTime.now().difference(lastSeen).inMinutes<2;
  }
}
