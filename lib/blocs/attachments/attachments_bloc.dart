import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:messio/models/message.dart';
import 'package:messio/models/video_wrapper.dart';
import 'package:messio/repositories/chat_repository.dart';
import 'package:messio/utils/shared_objects.dart';
import './bloc.dart';

class AttachmentsBloc extends Bloc<AttachmentsEvent, AttachmentsState> {
  final ChatRepository chatRepository;

  AttachmentsBloc({this.chatRepository}) :super(InitialAttachmentsState()){
    assert(chatRepository != null);
  on<FetchAttachmentsEvent>(mapFetchAttachmentsEventToState);
  }

  Future<void> mapFetchAttachmentsEventToState(
      FetchAttachmentsEvent event, Emitter<AttachmentsState> emit) async {
    int type = SharedObjects.getTypeFromFileType(event.fileType);
    List<Message> attachments =
        await chatRepository.getAttachments(event.chatId, type);
    if (event.fileType != FileType.video) {
      emit(FetchedAttachmentsState(event.fileType, attachments));
    } else {
      List<VideoWrapper> videos = List();
      for(Message message  in attachments){
        if (message is VideoMessage)  {
          File file = await SharedObjects.getThumbnail(message.videoUrl);
          videos.add(VideoWrapper(file, message));
        }
      }
      emit(FetchedVideosState(videos));
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
