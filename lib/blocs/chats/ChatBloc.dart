import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/repositories/ChatRepository.dart';
import 'package:messio/repositories/StorageRepository.dart';
import 'package:messio/repositories/UserDataRepository.dart';
import 'package:messio/utils/Exceptions.dart';
import 'package:messio/utils/SharedObjects.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;
  StreamSubscription messagesSubscription;
  StreamSubscription chatsSubscription;
  String activeChatId;
  ChatBloc(
      {this.chatRepository, this.userDataRepository, this.storageRepository})
      : assert(chatRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null);

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    print(event);
    if (event is FetchChatListEvent) {
      yield* mapFetchChatListEventToState(event);
    }
    if (event is ReceivedChatsEvent) {
      yield FetchedChatListState(event.chatList);
    }
    if (event is PageChangedEvent) {
      activeChatId = event.activeChat.chatId;
    }
    if (event is FetchConversationDetailsEvent) {
      dispatch(FetchMessagesEvent(event.chat));
      yield* mapFetchConversationDetailsEventToState(event);
    }
    if (event is FetchMessagesEvent) {
      yield* mapFetchMessagesEventToState(event);
    }
    if (event is ReceivedMessagesEvent) {
      print(event.messages);
      yield FetchedMessagesState(event.messages);
    }
    if (event is SendTextMessageEvent) {
      Message message = TextMessage(
          event.message,
          DateTime.now().millisecondsSinceEpoch,
          SharedObjects.prefs.getString(Constants.sessionName),
          SharedObjects.prefs.getString(Constants.sessionUsername));
      await chatRepository.sendMessage(activeChatId, message);
    }
    if (event is SendAttachmentEvent) {
      await mapPickedAttachmentEventToState(event);
    }
  }

  Stream<ChatState> mapFetchChatListEventToState(
      FetchChatListEvent event) async* {
    try {
      chatsSubscription?.cancel();
      chatsSubscription = chatRepository
          .getChats()
          .listen((chats) => dispatch(ReceivedChatsEvent(chats)));
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchMessagesEventToState(
      FetchMessagesEvent event) async* {
    try {
      yield InitialChatState();
      String chatId =
          await chatRepository.getChatIdByUsername(event.chat.username);
      print(chatId);
      messagesSubscription?.cancel();
      messagesSubscription = chatRepository
          .getMessages(chatId)
          .listen((messages) => dispatch(ReceivedMessagesEvent(messages)));
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchConversationDetailsEventToState(
      FetchConversationDetailsEvent event) async* {
    User user = await userDataRepository.getUser(event.chat.username);
    print(user);
    yield FetchedContactDetailsState(user);
  }

  Future mapPickedAttachmentEventToState(SendAttachmentEvent event) async {
    String url = await storageRepository.uploadFile(
        event.file, Paths.imageAttachmentsPath);
    String username = SharedObjects.prefs.getString(Constants.sessionUsername);
    String name = SharedObjects.prefs.getString(Constants.sessionName);
    Message message = VideoMessage(
        url, DateTime.now().millisecondsSinceEpoch, name, username);
    await chatRepository.sendMessage(event.chatId, message);
  }

  @override
  void dispose() {
    messagesSubscription.cancel();
    super.dispose();
  }
}
