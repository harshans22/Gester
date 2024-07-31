import 'package:firebase_auth/firebase_auth.dart';
import 'package:gester/firebase_methods/firestore_methods.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthMethods {
  var logger = Logger();
  final _auth = FirebaseAuth.instance;
  final _firestoreMethods = FireStoreMethods();

  Future<void> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      await _auth.signInWithCredential(credential);
      await _firestoreMethods.updateUserDataFirebase(
          googleUser!.photoUrl, googleUser.email); //updating userphotoUrl
    } catch (e) {
      logger.e(e.toString());
    }
    // await _firestoreMethods
    //     .createUserSubscriptionDetails();
  }

  Future<void> googleloginweb() async {
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithPopup(authProvider);
      final user = userCredential.user;
      await _firestoreMethods.updateUserDataFirebase(
          user!.photoURL, user.email); // Update user photo URL
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
