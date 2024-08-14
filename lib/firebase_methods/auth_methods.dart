import 'package:firebase_auth/firebase_auth.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthMethods {
  var logger = Logger();
  final _auth = FirebaseAuth.instance;
  final _firestoreMethods = FireStoreMethods();

  Future<String> googleLogin() async {
    String res = "";
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      await _auth.signInWithCredential(credential);
      await _firestoreMethods.updateUserDataFirebase(googleUser!.photoUrl,
          googleUser.email, googleUser.displayName); //updating userphotoUrl
      res = "success";
    } catch (e) {
      res = "fail";
      throw Exception(e);
    }
    return res;
  }

  Future<String> googleloginweb() async {
    String res = "";
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithPopup(authProvider);
      final user = userCredential.user;
      await _firestoreMethods.updateUserDataFirebase(user!.photoURL, user.email,
          user.displayName); // Update user photo URL
      res = "success";
    } catch (e) {
      res = "fail";
      throw Exception(e);
    }
    return res;
  }
}
