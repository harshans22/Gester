import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StoargeMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //adding image to firebase storage
   Future<String> uploadImageToStorage(
      String userId, Uint8List file,String childName) async {
    Reference ref =
        _storage.ref().child(childName).child(userId);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask; //  metadata data of uploaded file
    // to download link of our image which is stored in firestore
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}