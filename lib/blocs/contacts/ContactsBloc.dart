import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/repositories/UserDataRepository.dart';
import 'package:messio/utils/Exceptions.dart';
import './Bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  UserDataRepository userDataRepository;

  ContactsBloc({this.userDataRepository}) : assert(userDataRepository != null);

  @override
  ContactsState get initialState => InitialContactsState();

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    if (event is FetchContactsEvent) {
      yield* mapFetchContactsEventToState();
    } else if (event is AddContactEvent) {
      yield* mapAddContactEventToState(event.username);
    } else if (event is ClickedContactEvent) {
      yield* mapClickedContactEventToState();
    }

  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContactsState();
      List<Contact> contacts = await userDataRepository.getContacts();
      yield FetchedContactsState(contacts);
    } on MessioException catch(exception){
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddContactProgressState();
      await userDataRepository.addContact(username);
      yield AddContactSuccessState();
  } on MessioException catch(exception){
      print(exception.errorMessage());
  yield AddContactFailedState(exception);
  }
  }

  Stream<ContactsState> mapClickedContactEventToState() async* {
    //TODO: Redirect to chat screen
  }
}
