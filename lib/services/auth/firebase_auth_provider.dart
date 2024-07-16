import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:jevlis_ka/services/auth/auth_exceptions.dart';
import 'package:jevlis_ka/services/auth/auth_provider.dart';
import 'package:jevlis_ka/services/auth/auth_user.dart';
import 'package:jevlis_ka/firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        default:
          throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> userLogOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> userLogIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credentials':
          throw WrongPasswordAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      //TODO: Uncomment this line

      // provider.setCustomParameters({'prompt': 'select_account'});
      await FirebaseAuth.instance.signInWithPopup(provider);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (_) {
      throw GenericAuthException();
    }
  }
}
