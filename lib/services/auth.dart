import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<User?> signUpWithEmailAndPassword(
      {required String email, required String password, required String name});
  Future<void> logOut();
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
    // final googleSignIn = GoogleSignIn();
    try {
      //  await googleSignIn.signOut();
      await _fAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    }
  }

  @override
  Stream<User?> onAuthStateChanged() => _fAuth.authStateChanges();

  @override
  User? get currentUser => _fAuth.currentUser;
}
