String getChannelID(String senderId, String receiverId) {
  List ids = [senderId, receiverId];
  ids.sort();
  String channelId = ids.join(".");
  return channelId;
}
