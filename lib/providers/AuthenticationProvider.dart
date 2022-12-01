import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'BaseProviders.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {

   final FirebaseAuth firebaseAuth;
   final GoogleSignIn googleSignIn;

  AuthenticationProvider({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn}):
        firebaseAuth= firebaseAuth ?? FirebaseAuth.instance, googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount account =
        await googleSignIn.signIn(); //show the goggle login prompt
    final GoogleSignInAuthentication authentication =
        await account.authentication; //get the authentication object
    final AuthCredential credential = GoogleAuthProvider.credential(
        //retreive the authentication credentials
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    await firebaseAuth.signInWithCredential(
        credential); //sign in to firebase using the generated credentials
    final firebaseUser  = firebaseAuth.currentUser;
    await SharedObjects.prefs.setString(Constants.sessionUid, firebaseUser.uid);
    print('Session UID1 ${SharedObjects.prefs.getString(Constants.sessionUid)}');
    return firebaseUser; //return the firebase user created
  }

  @override
  Future<void> signOutUser() async {
    print('firebaseauth $firebaseAuth');
    await SharedObjects.prefs.clearSession();
    await Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]); // terminate the session
  }

  @override
  User getCurrentUser() {
    return firebaseAuth.currentUser; //retrieve the current user
  }

  @override
  bool isLoggedIn() {
    final user = firebaseAuth.currentUser; //check if user is logged in or not
    return user != null;
  }

  @override
  void dispose() {}
}
