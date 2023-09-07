bool isUsernameSafe(String username) {
  final regex = RegExp(r'^[a-zA-Z0-9_]+$');
  return regex.hasMatch(username);
}
