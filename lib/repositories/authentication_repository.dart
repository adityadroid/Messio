import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/providers/authentication_provider.dart';
import 'package:messio/providers/base_providers.dart';
import 'package:messio/repositories/base_repository.dart';

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
