import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/repositories/UserDataRepository.dart';
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
    List<Contact> contacts = await userDataRepository.getContacts();
    yield FetchedContactsState(contacts);
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    yield AddContactProgressState();
    try {
      await userDataRepository.addContact(username);
      await Future.delayed(Duration(milliseconds: 3000));
      yield AddContactSuccessState();
    }catch(_,stacktrace){
      await Future.delayed(Duration(milliseconds: 3000));
      print(stacktrace);
      yield AddContactFailedState();
    }
  }

  Stream<ContactsState> mapClickedContactEventToState() async* {
    //TODO: Redirect to chat screen
  }
}
