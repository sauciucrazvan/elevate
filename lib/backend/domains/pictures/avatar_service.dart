import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:elevate/backend/functions/username/get_username.dart';

class AvatarService {
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
      _avatarUpdateController.add(null);
    } catch (error) {
      return false;
    }

    return true;
  }

  Future<String> getAvatar(String username) async {
    Reference reference = FirebaseStorage.instance.ref();
    Reference directoryReference = reference.child('avatars');
    Reference imageReference = directoryReference.child(username);

    return await imageReference.getDownloadURL();
  }
}
