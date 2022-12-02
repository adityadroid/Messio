import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:messio/blocs/chats/bloc.dart';
import 'package:messio/config/constants.dart';
import 'package:messio/config/paths.dart';
import 'package:messio/models/message.dart';
import 'package:messio/models/messio_user.dart';
import 'package:messio/repositories/chat_repository.dart';
import 'package:messio/repositories/storage_repository.dart';
import 'package:messio/repositories/user_data_repository.dart';
import 'package:messio/utils/exceptions.dart';
import 'package:messio/utils/shared_objects.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;
  Map<String, StreamSubscription> messagesSubscriptionMap = Map();
  StreamSubscription chatsSubscription;
  String activeChatId;

  ChatBloc(
      {this.chatRepository, this.userDataRepository, this.storageRepository})
      : super(InitialChatState()){assert(chatRepository != null);
        assert(userDataRepository != null);
        assert(storageRepository != null);
        on<FetchChatListEvent>(mapFetchChatListEventToState);
        on<RegisterActiveChatEvent>(mapRegisterActiveChatEventToState);
        on<ReceivedChatsEvent>(mapReceivedChatsEventToState);
        on<PageChangedEvent>(mapPageChangedEventToState);
        on<FetchConversationDetailsEvent>(mapFetchConversationDetailsEventToState);
        on<FetchMessagesEvent>(mapFetchMessagesEventToState);
        on<FetchPreviousMessagesEvent>(mapFetchPreviousMessagesEventToState);
        on<ReceivedMessagesEvent>(mapReceivedMessagesEventToState);
        on<SendTextMessageEvent>(mapSendTextMessageEventToState);
        on<SendAttachmentEvent>(mapSendAttachmentEventToState);
        on<ToggleEmojiKeyboardEvent>(mapToggleEmojiKeyboardEventToState);
  }

  Future<void> mapFetchChatListEventToState(
      FetchChatListEvent event, Emitter<ChatState> emit) async {
    try {
      chatsSubscription?.cancel();
      chatsSubscription = chatRepository
          .getChats()
          .listen((chats) => add(ReceivedChatsEvent(chats)));
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      emit(ErrorState(exception));
    }
  }

  Future<void> mapFetchMessagesEventToState(
      FetchMessagesEvent event,  Emitter<ChatState> emit) async {
    try {
      emit(FetchingMessageState());
      String chatId =
          await chatRepository.getChatIdByUsername(event.chat.username);
      //  print('mapFetchMessagesEventToState');
      //  print('MessSubMap: $messagesSubscriptionMap');
      StreamSubscription messagesSubscription = messagesSubscriptionMap[chatId];
      messagesSubscription?.cancel();
      messagesSubscription = chatRepository.getMessages(chatId).listen((messages) => add(ReceivedMessagesEvent(messages, event.chat.username)));

      messagesSubscriptionMap[chatId] = messagesSubscription;
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      emit(ErrorState(exception));
    }
  }

  Future<void> mapFetchPreviousMessagesEventToState(
      FetchPreviousMessagesEvent event,  Emitter<ChatState> emit) async {
    try {
      String chatId =
          await chatRepository.getChatIdByUsername(event.chat.username);
      final messages =
          await chatRepository.getPreviousMessages(chatId, event.lastMessage);
      emit(FetchedMessagesState(messages, event.chat.username,
          isPrevious: true));
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      emit(ErrorState(exception));
    }
  }

  Future<void> mapFetchConversationDetailsEventToState(
      FetchConversationDetailsEvent event,  Emitter<ChatState> emit) async {
    print('fetching details fro ${event.chat.username}');
    MessioUser user = await userDataRepository.getUser(event.chat.username);
    emit(FetchedContactDetailsState(user, event.chat.username));
    add(FetchMessagesEvent(event.chat));
  }

  Future<void> mapSendAttachmentEventToState(SendAttachmentEvent event, Emitter<ChatState> emit) async {
    File file = event.file;
    String fileName = basename(file.path);
    String url = await storageRepository.uploadFile(
        file, Paths.getAttachmentPathByFileType(event.fileType));
    String username = SharedObjects.prefs.getString(Constants.sessionUsername);
    String name = SharedObjects.prefs.getString(Constants.sessionName);
    print('File Name: $fileName');
    Message message;
    if (event.fileType == FileType.image)
      message = ImageMessage(
          url, fileName, DateTime.now().millisecondsSinceEpoch, name, username);
    else if (event.fileType == FileType.video)
      message = VideoMessage(
          url, fileName, DateTime.now().millisecondsSinceEpoch, name, username);
    else
      message = FileMessage(
          url, fileName, DateTime.now().millisecondsSinceEpoch, name, username);
    await chatRepository.sendMessage(event.chatId, message);
  }

  Future<void> mapRegisterActiveChatEventToState(RegisterActiveChatEvent event, Emitter<ChatState> emit) async {
    activeChatId = event.activeChatId;
  }

  Future<void> mapReceivedChatsEventToState(ReceivedChatsEvent event, Emitter<ChatState> emit)async {
    emit(FetchedChatListState(event.chatList));
  }

  Future<void> mapPageChangedEventToState(PageChangedEvent event, Emitter<ChatState> emit)async {
    activeChatId = event.activeChat.chatId;
    emit(PageChangedState(event.index, event.activeChat));
  }

  Future<void> mapReceivedMessagesEventToState(ReceivedMessagesEvent event, Emitter<ChatState> emit) async {
    print('dispatching received messages');
    emit(FetchedMessagesState(event.messages, event.username,
        isPrevious: false));
  }

  Future<void> mapSendTextMessageEventToState(SendTextMessageEvent event, Emitter<ChatState> emit) async{
    Message message = TextMessage(
        event.message,
        DateTime.now().millisecondsSinceEpoch,
        SharedObjects.prefs.getString(Constants.sessionName),
        SharedObjects.prefs.getString(Constants.sessionUsername));
    await chatRepository.sendMessage(activeChatId, message);
  }

  Future<void> mapToggleEmojiKeyboardEventToState(ToggleEmojiKeyboardEvent event, Emitter<ChatState> emit)async {
    emit(ToggleEmojiKeyboardState(event.showEmojiKeyboard));

  }

  @override
  Future<void> close() {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    return super.close();
  }

}
