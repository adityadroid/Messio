import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messio/blocs/authentication/AuthenticationBloc.dart';
import 'package:messio/blocs/authentication/AuthenticationEvent.dart';
import 'package:messio/blocs/authentication/AuthenticationState.dart';
import 'package:messio/models/User.dart';
import 'package:mockito/mockito.dart';

import '../mock/FirebaseMock.dart';
import '../mock/IOMock.dart';
import '../mock/RepositoryMock.dart';

void main() {
  AuthenticationBloc authenticationBloc;
  AuthenticationRepositoryMock authenticationRepository;
  UserDataRepositoryMock userDataRepository;
  StorageRepositoryMock storageRepository;
  FirebaseUserMock firebaseUser;
  User user;
  MockFile file;
  int age;
  String username;
  String profilePictureUrl;

  setUp(() {
    userDataRepository = UserDataRepositoryMock();
    authenticationRepository = AuthenticationRepositoryMock();
    storageRepository = StorageRepositoryMock();
    firebaseUser = FirebaseUserMock();
    user = User();
    file = MockFile();
    age = 23;
    username = 'johndoe';
    profilePictureUrl = 'http://www.github.com/adityadroid';
    authenticationBloc = AuthenticationBloc(
        userDataRepository: userDataRepository,
        authenticationRepository: authenticationRepository,
        storageRepository: storageRepository);
  });

  test('initial state is always AuthInProgress', () {
    expect(authenticationBloc.initialState, Uninitialized());
  });

  //test the sequence of event emissions for different conditions
  group('AppLaunched', () {
    test('emits [Uninitialized -> Unauthenticated] when not logged in', () {
      when(authenticationRepository.isLoggedIn())
          .thenAnswer((_) => Future.value(false));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        UnAuthenticated()
      ];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));

      authenticationBloc.dispatch(AppLaunched());
    });
    test('emits [Uninitialized -> ProfileUpdated] when user is logged in and profile is complete', () {
      when(authenticationRepository.isLoggedIn())
          .thenAnswer((_) => Future.value(true));
      when(authenticationRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(FirebaseUserMock()));
      when(userDataRepository.isProfileComplete(any))
          .thenAnswer((_) => Future.value(true));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        ProfileUpdated()
      ];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));

      authenticationBloc.dispatch(AppLaunched());
    });
    test('emits [Uninitialized -> AuthInProgress -> Authenticated -> ProfileUpdateInProgress -> PreFillData] when user is logged in and profile is not complete', () {
      when(authenticationRepository.isLoggedIn())
          .thenAnswer((_) => Future.value(true));
      when(authenticationRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(firebaseUser));
      when(userDataRepository.isProfileComplete(any))
          .thenAnswer((_) => Future.value(false));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        Authenticated(firebaseUser),
        ProfileUpdateInProgress(),
        PreFillData(user)
      ];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));

      authenticationBloc.dispatch(AppLaunched());
    });
  });

  group('ClickedGoogleLogin', () {
    test('emits [AuthInProgress -> ProfileUpdated] when the user clicks Google Login button and after login result, the profile is complete', () {
      when(authenticationRepository.signInWithGoogle())
          .thenAnswer((_) => Future.value(firebaseUser));
      when(userDataRepository.isProfileComplete(any))
          .thenAnswer((_) => Future.value(true));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        ProfileUpdated()
      ];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));
      authenticationBloc.dispatch(ClickedGoogleLogin());
    });

    test('emits [AuthInProgress -> Authenticated -> ProfileUpdateInProgress -> PreFillData] when the user clicks Google Login button and after login result, the profile is found to be incomplete', () {
      when(authenticationRepository.signInWithGoogle())
          .thenAnswer((_) => Future.value(firebaseUser));
      when(userDataRepository.isProfileComplete(any))
          .thenAnswer((_) => Future.value(false));
      final expectedStates = [
        Uninitialized(),
        AuthInProgress(),
        Authenticated(firebaseUser),
        ProfileUpdateInProgress(),
        PreFillData(user)
      ];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));
      authenticationBloc.dispatch(ClickedGoogleLogin());
    });
  });

  group('LoggedIn', () {
    test('emits [ProfileUpdateInProgress -> PreFillData] when trigged, this event is trigged once gauth is done and profile is not complete', () {
      when(userDataRepository.saveDetailsFromGoogleAuth(firebaseUser))
          .thenAnswer((_) => Future.value(user));
      final expectedStates = [
        Uninitialized(),
        ProfileUpdateInProgress(),
        PreFillData(user)
      ];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));

      authenticationBloc.dispatch(LoggedIn(firebaseUser));
    });
  });

  group('PickedProfilePicture', () {
    test('emits [ReceivedProfilePicture] everytime', () {
      final expectedStates = [Uninitialized(), ReceivedProfilePicture(file)];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));
      authenticationBloc.dispatch(PickedProfilePicture(file));
    });
  });

  group('SaveProfile', () {
    test('emits [ProfileUpdateInProgress -> ProfileUpdated] everytime SaveProfile is dispatched', () {
      when(storageRepository.uploadImage(any, any))
          .thenAnswer((_) => Future.value(profilePictureUrl));
      when(authenticationRepository.getCurrentUser())
          .thenAnswer((_) => Future.value(firebaseUser));
      when(userDataRepository.saveProfileDetails(any, any, any, any))
          .thenAnswer((_) => Future.value(user));
      final expectedStates = [
        Uninitialized(),
        ProfileUpdateInProgress(),
        ProfileUpdated()
      ];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));
      authenticationBloc.dispatch(SaveProfile(file, age, username));
    });
  });

  group('ClickedLogout', () {
    test('emits [UnAuthenticated] when clicked logout', () {
      final expectedStates = [Uninitialized(), UnAuthenticated()];
      expectLater(authenticationBloc.state, emitsInOrder(expectedStates));
      authenticationBloc.dispatch(ClickedLogout());
    });
  });

  test('emits no states after calling dispose', () {
    expectLater(
      authenticationBloc.state,
      emitsInOrder([]),
    );
    authenticationBloc.dispose();
  });
}
