// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image/image.dart' as img;

import 'package:elevate/backend/functions/username/get_username.dart';

import 'package:elevate/frontend/widgets/notifications/elevated_notification.dart';

class AvatarService {
  // Singleton class
  static final AvatarService _instance = AvatarService._internal();

  AvatarService._internal();

  factory AvatarService() {
    return _instance;
  }

  // Values

  final Map<String, String> _avatarCache = {};

  final StreamController<void> _avatarUpdateController =
      StreamController<void>.broadcast();
  Stream<void> get onAvatarUpdate => _avatarUpdateController.stream;

  // Functions

  Future<File?> resizeAndCheckSize(File file, int maxSizeInBytes) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(bytes));

    if (image == null) {
      return null;
    }

    int targetWidth = 256;
    int targetHeight = 256;

    double scaleFactorWidth = targetWidth / image.width;
    double scaleFactorHeight = targetHeight / image.height;

    double scaleFactor = scaleFactorWidth < scaleFactorHeight
        ? scaleFactorWidth
        : scaleFactorHeight;

    int newWidth = (image.width * scaleFactor).round();
    int newHeight = (image.height * scaleFactor).round();

    final resizedImage =
        img.copyResize(image, width: newWidth, height: newHeight);

    final compressedBytes = img.encodeJpg(resizedImage, quality: 100);

    if (compressedBytes.length > maxSizeInBytes) {
      return null;
    }

    final resizedFile = File('${file.path}.jpg');
    await resizedFile.writeAsBytes(compressedBytes);

    return resizedFile;
  }

  Future<bool> pickAvatar() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return false;

    String fileName = getUsername(FirebaseAuth.instance.currentUser)!;

    if (fileName == "elevate") {
      return false; // Can't change the @elevate account image
    }

    Reference reference = FirebaseStorage.instance.ref();
    Reference directoryReference = reference.child('avatars');
    Reference imageReference = directoryReference.child(fileName);

    try {
      const maxSizeInBytes = 1 * 1024 * 1024;
      final resizedFile =
          await resizeAndCheckSize(File(file.path), maxSizeInBytes);

      if (resizedFile == null) {
        return false;
      }

      await imageReference.putFile(resizedFile);

      _avatarCache[fileName] = await imageReference.getDownloadURL();
      _avatarUpdateController.add(null);
    } catch (error) {
      return false;
    }

    return true;
  }

  void changeAvatar(BuildContext context) async {
    bool successfullyChanged = await pickAvatar();

    if (!successfullyChanged) {
      showElevatedNotification(
        context,
        "There was an error uploading your avatar.",
        Colors.red,
      );
    } else {
      showElevatedNotification(
        context,
        "Avatar changed successfully.",
        Colors.lightGreen.shade800,
      );
    }
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
