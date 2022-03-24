import 'package:customizable_app/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  FirebaseAuth? _auth;
  static final AuthenticationService _authInstance =
      AuthenticationService._init();

  AuthenticationService._init();

  static AuthenticationService get instance {
    return _authInstance;
  }

  static authInit() {
    _authInstance._auth ??= FirebaseAuth.instance;
    return;
  }

  Future<void> signOut() async {
    await _auth?.signOut();
  }

  String getUserId() {
    return _auth?.currentUser?.uid ?? "";
  }

  Future<bool> loginWithMail(String email, String password) async {
    bool isLoggedIn = false;
    try {
      UserCredential userCredential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user?.uid != null) {
        isLoggedIn = true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return isLoggedIn;
  }

  Future<bool> signInWithMail(
      String? name, String? surname, String email, String password) async {
    bool isSignedIn = false;
    try {
      UserCredential userCredential =
          await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await UserService.instance
          .recordUser(name, surname, userCredential.user!.uid);

      if (userCredential.user?.uid != null) {
        isSignedIn = true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //TODO
      } else if (e.code == 'email-already-in-use') {
        //TODO
      }
    } catch (e) {
      print(e);
    }
    return isSignedIn;
  }
}
