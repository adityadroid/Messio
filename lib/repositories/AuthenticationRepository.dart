import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/providers/AuthenticationProvider.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/repositories/BaseRepository.dart';

class AuthenticationRepository extends BaseRepository {

  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();

  Future<User> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => authenticationProvider.signOutUser();

  User getCurrentUser() => authenticationProvider.getCurrentUser();

  bool isLoggedIn() => authenticationProvider.isLoggedIn();

  @override
  void dispose() {
    authenticationProvider.dispose();
  }
}
