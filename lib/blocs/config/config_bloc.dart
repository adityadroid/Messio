import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/config/paths.dart';
import 'package:messio/repositories/storage_repository.dart';
import 'package:messio/repositories/user_data_repository.dart';
import 'package:messio/utils/shared_objects.dart';
import 'bloc.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  UserDataRepository userDataRepository;
  StorageRepository storageRepository;

  ConfigBloc({this.userDataRepository, this.storageRepository})
      : super(UnConfigState()){assert(userDataRepository != null);
        assert(storageRepository != null);}


  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    if (event is ConfigValueChanged) {
      SharedObjects.prefs.setBool(event.key, event.value);
      yield ConfigChangeState(event.key, event.value);
    }
    if (event is UpdateProfilePicture) {
      yield* mapUpdateProfilePictureToState(event);
    }
    if (event is RestartApp){
      yield RestartedAppState();
    }
  }

  Stream<ConfigState> mapUpdateProfilePictureToState(
      UpdateProfilePicture event) async* {
    yield UpdatingProfilePictureState();
    final  profilePictureUrl = await storageRepository.uploadFile(event.file, Paths.profilePicturePath);
    await userDataRepository.updateProfilePicture(profilePictureUrl);
    yield ProfilePictureChangedState(profilePictureUrl);
  }
}
