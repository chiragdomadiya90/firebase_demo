import '../view/constant.dart';

class FirebaseAuthServices {
  static Future<bool> signUp({String? email, String? password}) async {
    await kFirebaseAuth.createUserWithEmailAndPassword(
        email: email!, password: password!);
    return true;
  }

  static Future<bool> logIn({String? email, String? password}) async {
    await kFirebaseAuth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .catchError((e) {
      print("LOGIN ERROR==>>$e");
    });
    return true;
  }

  static Future logOut() async {
    await kFirebaseAuth.signOut();
  }
}
