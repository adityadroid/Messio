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
    on<FetchContactsEvent>(mapFetchContactsEventToState);
    on<ReceivedContactsEvent>(mapReceivedContactsEventToState);
    on<AddContactEvent>(mapAddContactEventToState);
  }
  Future<void> mapReceivedContactsEventToState(ReceivedContactsEvent event, Emitter<ContactsState> emit)async{
    emit(FetchedContactsState(event.contacts));
  }
  Future<void> mapFetchContactsEventToState(FetchContactsEvent event, Emitter<ContactsState> emit) async {
    try {
      emit(FetchingContactsState());
      subscription?.cancel();
      subscription = userDataRepository.getContacts().listen((contacts) => {
            print('dispatching $contacts'),
            add(ReceivedContactsEvent(contacts))
          });
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      emit(ErrorState(exception));
    }
  }

  Future<void> mapAddContactEventToState(AddContactEvent event,Emitter<ContactsState> emit) async {
    userDataRepository.getUser(event.username);
    try {
      emit(AddContactProgressState());
      await userDataRepository.addContact(event.username);
      MessioUser user = await userDataRepository.getUser(event.username);
      await chatRepository.createChatIdForContact(user);
      emit(AddContactSuccessState());
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      emit( AddContactFailedState(exception));
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
