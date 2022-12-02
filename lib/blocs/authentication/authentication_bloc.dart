import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/config/paths.dart';
import 'package:messio/repositories/authentication_repository.dart';
import 'package:messio/repositories/storage_repository.dart';
import 'package:messio/repositories/user_data_repository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  AuthenticationBloc(
      {this.authenticationRepository,
      this.userDataRepository,
      this.storageRepository}) : super(Uninitialized()){
    assert(authenticationRepository != null);
    assert(userDataRepository != null);
    assert(storageRepository != null);
    on<AppLaunched>(mapAppLaunchedToState);
    on<ClickedGoogleLogin>(mapClickedGoogleLoginToState);
    on<LoggedIn>(mapLoggedInToState);
    on<PickedProfilePicture>(mapPickedProfilePictureToState);
    on<SaveProfile>(mapSaveProfileToState);
    on<ClickedLogout>(mapLoggedOutToState);
  }

  Future<void> mapPickedProfilePictureToState(PickedProfilePicture event,Emitter<AuthenticationState> emit) async {
    emit(ReceivedProfilePicture(event.file));
  }

  Future<void> mapAppLaunchedToState(AppLaunched event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthInProgress()); //show the progress bar
      final isSignedIn = authenticationRepository.isLoggedIn(); // check if user is signed in
      if (isSignedIn) {
        final user = authenticationRepository.getCurrentUser();
        bool isProfileComplete =
            await userDataRepository.isProfileComplete(); // if he is signed in then check if his profile is complete
        print(isProfileComplete);
        if (isProfileComplete) {      //if profile is complete then redirect to the home page
          emit(ProfileUpdated());
        } else {
           emit(Authenticated(user)); // else yield the authenticated state and redirect to profile page to complete profile.
          add(LoggedIn(user)); // also disptach a login event so that the data from gauth can be prefilled
        }
      } else {
        emit(UnAuthenticated()); // is not signed in then show the home page
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      emit(UnAuthenticated());
    }
  }

  Future<void> mapClickedGoogleLoginToState(ClickedGoogleLogin event, Emitter<AuthenticationState> emit) async {
    emit(AuthInProgress());  //show progress bar
    try {
      User firebaseUser =
          await authenticationRepository.signInWithGoogle(); // show the google auth prompt and wait for user selection, retrieve the selected account
      bool isProfileComplete =
          await userDataRepository.isProfileComplete(); // check if the user's profile is complete
      print('isProfileComplete $isProfileComplete');
      if (isProfileComplete) {
        emit(ProfileUpdated()); //if profile is complete go to home page
      } else {
        emit(Authenticated(firebaseUser)); // else yield the authenticated state and redirect to profile page to complete profile.
        add(LoggedIn(firebaseUser)); // also dispatch a login event so that the data from gauth can be prefilled
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      emit(UnAuthenticated()); // in case of error go back to first registration page
    }
  }

  Future<void> mapLoggedInToState(
  LoggedIn event,Emitter<AuthenticationState> emit) async {
    emit(ProfileUpdateInProgress()); // shows progress bar
    final user = await userDataRepository.saveDetailsFromGoogleAuth(event.user); // save the gAuth details to firestore database
    emit(PreFillData(user)); // prefill the gauth data in the form
  }

  Future<void> mapSaveProfileToState(
      SaveProfile event, Emitter<AuthenticationState> emit) async {
    emit(ProfileUpdateInProgress()); // shows progress bar
    String profilePictureUrl = await storageRepository.uploadFile(
        event.profileImage, Paths.profilePicturePath); // upload image to firebase storage
    final user = authenticationRepository.getCurrentUser(); // retrieve user from firebase
    await userDataRepository.saveProfileDetails(
        user.uid, profilePictureUrl, event.age, event.username); // save profile details to firestore
    emit(ProfileUpdated()); //redirect to home page
  }

  Future<void> mapLoggedOutToState(ClickedLogout event, Emitter<AuthenticationState> emit) async {
     emit(UnAuthenticated()); // redirect to login page
    authenticationRepository.signOutUser(); // terminate session
  }

}
