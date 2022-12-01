import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/repositories/ChatRepository.dart';
import './Bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  ChatRepository chatRepository;

  HomeBloc({this.chatRepository}):super(InitialHomeState()){
    assert(chatRepository != null);
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    print(event);
    if (event is FetchHomeChatsEvent) {
      yield FetchingHomeChatsState();
      chatRepository.getConversations().listen(
            (conversations) => add(ReceivedChatsEvent(conversations)));
    }
    if (event is ReceivedChatsEvent) {
      yield FetchingHomeChatsState();
      yield FetchedHomeChatsState(event.conversations);
    }
  }

}
