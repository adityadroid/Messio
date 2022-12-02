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
        assert(storageRepository != null);
    on<ConfigValueChanged>(mapConfigValueChangedToState);
    on<UpdateProfilePicture>(mapUpdateProfilePictureToState);
    on<RestartApp>(mapRestartAppToState);
  }

   Future<void> mapUpdateProfilePictureToState(
      UpdateProfilePicture event,Emitter<ConfigState> emit) async {
    emit(UpdatingProfilePictureState());
    final  profilePictureUrl = await storageRepository.uploadFile(event.file, Paths.profilePicturePath);
    await userDataRepository.updateProfilePicture(profilePictureUrl);
    emit(ProfilePictureChangedState(profilePictureUrl));
  }

  Future<void> mapConfigValueChangedToState(ConfigValueChanged event, Emitter<ConfigState> emit) async {
    SharedObjects.prefs.setBool(event.key, event.value);
    emit(ConfigChangeState(event.key, event.value));
  }

  Future<void> mapRestartAppToState(RestartApp event, Emitter<ConfigState> emit)async {
    emit(RestartedAppState());
  }
}
