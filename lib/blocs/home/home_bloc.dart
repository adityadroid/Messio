import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/repositories/chat_repository.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  ChatRepository chatRepository;

  HomeBloc({this.chatRepository}):super(InitialHomeState()){
    assert(chatRepository != null);
    on<FetchHomeChatsEvent>(mapFetchHomeChatsEventToState);
    on<ReceivedChatsEvent>(mapReceivedChatsEventToState);
  }

  Future<void> mapReceivedChatsEventToState(ReceivedChatsEvent event, Emitter<HomeState> emit) async {
    emit(FetchingHomeChatsState());
    emit(FetchedHomeChatsState(event.conversations));
  }
  Future<void> mapFetchHomeChatsEventToState(FetchHomeChatsEvent event, Emitter<HomeState> emit) async {
    emit(FetchingHomeChatsState());
    chatRepository.getConversations().listen(
            (conversations) => add(ReceivedChatsEvent(conversations)));
  }
}
