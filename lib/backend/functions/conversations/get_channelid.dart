String getChannelID(String senderName, String receiverName) {
  List ids = [senderName, receiverName];
  ids.sort();
  String channelId = ids.join(".");
  return channelId;
}
