import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/models/messio_user.dart';
import 'package:messio/repositories/chat_repository.dart';
import 'package:messio/repositories/user_data_repository.dart';
import 'package:messio/utils/exceptions.dart';
import './bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  UserDataRepository userDataRepository;
  ChatRepository chatRepository;
  StreamSubscription subscription;

  ContactsBloc({this.userDataRepository, this.chatRepository})
      : super(InitialContactsState()){
    assert(userDataRepository != null);
    assert(chatRepository != null);
  }
  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    if (event is FetchContactsEvent) {
      try {
        yield FetchingContactsState();
        subscription?.cancel();
        subscription = userDataRepository.getContacts().listen((contacts) => {
              print('dispatching $contacts'),
              add(ReceivedContactsEvent(contacts))
            });
      } on MessioException catch (exception) {
        print(exception.errorMessage());
        yield ErrorState(exception);
      }
    }
    if (event is ReceivedContactsEvent) {
      yield FetchedContactsState(event.contacts);
    }
    if (event is AddContactEvent) {
      userDataRepository.getUser(event.username);
      yield* mapAddContactEventToState(event.username);
    }
  
  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContactsState();
      subscription?.cancel();
      subscription = userDataRepository.getContacts().listen((contacts) => {
            print('dispatching $contacts'),
            add(ReceivedContactsEvent(contacts))
          });
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddContactProgressState();
      await userDataRepository.addContact(username);
      MessioUser user = await userDataRepository.getUser(username);
      await chatRepository.createChatIdForContact(user);
      yield AddContactSuccessState();
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      yield AddContactFailedState(exception);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
