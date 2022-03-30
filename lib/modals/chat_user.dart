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
}
