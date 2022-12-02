import 'package:messio/repositories/authentication_repository.dart';
import 'package:messio/repositories/storage_repository.dart';
import 'package:messio/repositories/user_data_repository.dart';
import 'package:mockito/mockito.dart';

class AuthenticationRepositoryMock extends Mock implements AuthenticationRepository{}
class UserDataRepositoryMock extends Mock implements UserDataRepository{}
class StorageRepositoryMock extends Mock implements StorageRepository{}