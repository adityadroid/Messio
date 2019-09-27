import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/VideoWrapper.dart';
import 'package:messio/repositories/ChatRepository.dart';
import 'package:messio/utils/SharedObjects.dart';
import './Bloc.dart';

class AttachmentsBloc extends Bloc<AttachmentsEvent, AttachmentsState> {
  final ChatRepository chatRepository;

  AttachmentsBloc({this.chatRepository}) : assert(chatRepository != null);

  @override
  AttachmentsState get initialState => InitialAttachmentsState();

  @override
  Stream<AttachmentsState> mapEventToState(
    AttachmentsEvent event,
  ) async* {
    print(event);
    if (event is FetchAttachmentsEvent) {
      yield* mapFetchAttachmentsEventToState(event);
    }
  }

  Stream<AttachmentsState> mapFetchAttachmentsEventToState(
      FetchAttachmentsEvent event) async* {
    int type = SharedObjects.getTypeFromFileType(event.fileType);
    List<Message> attachments =
        await chatRepository.getAttachments(event.chatId, type);
    if (event.fileType != FileType.VIDEO) {
      yield FetchedAttachmentsState(event.fileType, attachments);
    } else {
      List<VideoWrapper> videos = List();
      for(Message message  in attachments){
        if (message is VideoMessage)  {
          File file = await SharedObjects.getThumbnail(message.videoUrl);
          videos.add(VideoWrapper(file, message));
        }
      }
      yield FetchedVideosState(videos);
    }
  }

  FutureOr<List<VideoWrapper>> parseVideos(List<Message> attachments) async{
    List<VideoWrapper> videos = List();
    for(Message message  in attachments){
      if (message is VideoMessage)  {
        File file = await SharedObjects.getThumbnail(message.videoUrl);
        videos.add(VideoWrapper(file, message));
      }
    }
    return videos;
  }
}
