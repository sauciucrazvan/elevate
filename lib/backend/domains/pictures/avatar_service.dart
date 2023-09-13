import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:elevate/backend/functions/username/get_username.dart';

class AvatarService {
  // Singleton class
  static final AvatarService _instance = AvatarService._internal();

  AvatarService._internal();

  factory AvatarService() {
    return _instance;
  }

  final Map<String, String> _avatarCache = {};

  final StreamController<void> _avatarUpdateController =
      StreamController<void>.broadcast();
  Stream<void> get onAvatarUpdate => _avatarUpdateController.stream;

  Future<bool> pickAvatar() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return false;

    String fileName = getUsername(FirebaseAuth.instance.currentUser)!;

    Reference reference = FirebaseStorage.instance.ref();
    Reference directoryReference = reference.child('avatars');
    Reference imageReference = directoryReference.child(fileName);

    try {
      await imageReference.putFile(File(file.path));

      _avatarCache[fileName] = await imageReference.getDownloadURL();
      _avatarUpdateController.add(null);
    } catch (error) {
      return false;
    }

    return true;
  }

  Future<String> getAvatar(String username) async {
    if (_avatarCache.containsKey(username)) {
      return _avatarCache[username]!;
    }

    Reference reference = FirebaseStorage.instance.ref();
    Reference directoryReference = reference.child('avatars');

    String url;

    try {
      url = await directoryReference.child(username).getDownloadURL();
    } catch (error) {
      url = await directoryReference.child('default').getDownloadURL();
    }

    _avatarCache[username] = url;

    return url;
  }
}
