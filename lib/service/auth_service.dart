import 'package:customizable_app/service/user.dart';
import 'package:customizable_app/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/app_contants.dart';

class AuthenticationService {
  FirebaseAuth? _auth;
  static final AuthenticationService _authInstance =
      AuthenticationService._init();
  static UserModel user = UserModel(type: -1);
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

  Future<UserModel?> getUser() async {
    if (user.type != -1) {
      return user;
    } else {
      return await getUserApi();
    }
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
        user = (await getUserApi())!;
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

  Future<UserModel?> getUserApi() async {
    Map<String, dynamic> data = {
      "user_id": AuthenticationService.instance.getUserId(),
    };
    try {
      Response response = await Dio()
          .get(AppConstants.apiUrl + "/getUserByUserId", queryParameters: data);
      Map<String, dynamic> dataMap = response.data;
      List dataList = dataMap["DB_user"];
      user = UserModel.fromMap(dataList.first);
      return UserModel.fromMap(dataList.first);
    } catch (e) {
      print(e);
    }
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
      //TODO USER TYPE
      await UserService.instance
          .createNewUser(name, surname, userCredential.user!.uid, 0);

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
