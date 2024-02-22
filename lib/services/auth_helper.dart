import 'package:diary/services/auth_ecxeption_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {

  AuthHelper._();
  static final AuthHelper auth = AuthHelper._();

  //use _ for private variables
  static final FirebaseAuth? _authInstance = FirebaseAuth.instance;

  Future<void> logout() async{
    await _authInstance!.signOut();
  }

  Future<AuthStatus> login(String email, String password) async{
    try {
      await _authInstance!.signInWithEmailAndPassword(email: email, password: password);
      return AuthStatus.successful;
    } on  FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    }
  }

  Future<AuthStatus> register(String email, String password, String name) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      //add store to SharedPreferences
      _authInstance!.currentUser!.updateDisplayName(name);
      return AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  Future<AuthStatus> resetPassword(String email) async {
    try{
      _authInstance!
          .sendPasswordResetEmail(email: email);
      return AuthStatus.successful;
    }on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  bool isAuthorized(){
    bool isAuth = false;
    _authInstance!
        .authStateChanges()
        .listen((User? user) {
      if (user != null) {
        isAuth = true;
      }
    });
    return isAuth;
  }
}
