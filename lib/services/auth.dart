import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hoteldise/services/firestore.dart';

abstract class AuthBase {
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<User?> signInWithGoogle();
  Future<User?> signUpWithEmailAndPassword(
      {required String email, required String password, required String name});
  Future<void> logOut();
  Future<String?> updateUserName(String newUserName);
  User? get currentUser;
  Stream<User?> onAuthStateChanged();
}

class AuthService implements AuthBase {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  @override
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCred = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _fAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Future<User?> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCred = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCred.user;
      await user?.updateDisplayName(name);
      return user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    }
  }

  @override
  Future<void> logOut() async {
    final googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await _fAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    }
  }

  @override
  Future<String?> updateUserName(String newUserName) async {
    try {
      await _fAuth.currentUser!.updateDisplayName(newUserName);
      return _fAuth.currentUser!.displayName;
    } catch (e) {}
  }

  @override
  Stream<User?> onAuthStateChanged() => _fAuth.authStateChanges();

  @override
  User? get currentUser => _fAuth.currentUser;
}
