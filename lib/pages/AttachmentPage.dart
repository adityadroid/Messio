import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/blocs/attachments/Bloc.dart';
import 'package:messio/models/VideoWrapper.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:messio/widgets/BottomSheetFixed.dart';
import 'package:messio/widgets/ImageFullScreenWidget.dart';
import 'package:messio/widgets/VideoPlayerWidget.dart';

class AttachmentPage extends StatefulWidget {
  final String chatId;
  final FileType fileType;

  AttachmentPage(this.chatId, this.fileType);

  @override
  _AttachmentPageState createState() =>
      _AttachmentPageState(this.chatId, this.fileType);
}

class _AttachmentPageState extends State<AttachmentPage>
    with SingleTickerProviderStateMixin {
  final String chatId;
  final FileType initialFileType;
  List<ImageMessage> photos;
  List<VideoWrapper> videos;
  List<FileMessage> files;

  AttachmentsBloc attachmentsBloc;
  String tempThumbnailPath;
  TabController tabController;

  _AttachmentPageState(this.chatId, this.initialFileType);

  @override
  void initState() {
    super.initState();
    attachmentsBloc = BlocProvider.of<AttachmentsBloc>(context);
    int initialTab = SharedObjects.getTypeFromFileType(initialFileType); // get the initial index of tab. 0/1/2
    tabController =
        TabController(initialIndex: initialTab - 1, length: 3, vsync: this);
    tabController.addListener(() {
      int index = tabController.index;
      if (index == 0 && photos == null) // if photos are not initialized and we're on the first tab then trigger a fetch event for photos
        attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, FileType.IMAGE));
      else if (index == 1 && videos == null) // if videos are not initialized and we're on the second tab then  trigger a fetch event for videos
        attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, FileType.VIDEO));
      else if (index == 2 && files == null) //if files are not initialized and we're on the third tab then trigger a fetch event for files
        attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, FileType.ANY));
    });
    attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, initialFileType)); // triggers at the very start.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  expandedHeight: 180.0,
                  pinned: true,
                  elevation: 0,
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Attachments", style: Theme.of(context).textTheme.title),
                  ),
                ),
              SliverToBoxAdapter(child:
              TabBar(
                controller: tabController,
                tabs: [
                  Tab(icon: Icon(Icons.photo), text: "Photos"),
                  Tab(icon: Icon(Icons.videocam), text: "Videos"),
                  Tab(icon: Icon(Icons.insert_drive_file), text: "Files"),
                ],
              ),)
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: [
                buildPhotosGrid(),
                buildVideosGrid(),
                buildFilesGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildPhotosGrid() {
    return BlocBuilder<AttachmentsBloc, AttachmentsState>(
        builder: (context, state) {
      print('Received $state');
      if (state is FetchedAttachmentsState &&
          state.fileType == FileType.IMAGE) {
        photos = List();
        state.attachments.forEach((msg) {
          if (msg is ImageMessage) {
            photos.add(msg);
          }
        });
      }
      if (photos == null)
        return Center(child: CircularProgressIndicator()); // if uninit, show a progress bar
      else if (photos.length == 0) { // if init and the photos array size is 0
        return Center(
            child: Text(
          'No Photos',
          style: Theme.of(context).textTheme.body2,
        ));
      }
      return GridView.count( //otherwise show a grid of photos
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children: List.generate(photos.length, (index) => imageItem(context, index)),
      );
    });
  }



  buildVideosGrid() {
    return BlocBuilder<AttachmentsBloc, AttachmentsState>(
        builder: (context, state) {
      print('Received $state');
      if (state is FetchedVideosState) {
        videos = state.videos;
      }
      if (videos == null) // if uninit, then show a progress bar
        return Center(child: CircularProgressIndicator());
      else if (videos.length == 0) { // if init and videos length is zero
        return Center(
            child: Text(
          'No Videos',
              style: Theme.of(context).textTheme.body2,
        ));
      }
      return GridView.count( //else show a grid of videos using their thumbnails
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children:
            List.generate(videos.length, (index) => videoItem(videos[index])),
      );
    });
  }

  buildFilesGrid() {
    return BlocBuilder<AttachmentsBloc, AttachmentsState>(
        builder: (context, state) {
      print('Received $state in ui');
      if (state is FetchedAttachmentsState && state.fileType == FileType.ANY) {
        files = List();
        state.attachments.forEach((msg) {
          if (msg is FileMessage) {
            files.add(msg);
          }
        });
      }
      if (files == null) // if uninit show a progress bar
        return Center(child: CircularProgressIndicator());
      else if (files.length == 0) { //if files array length is zero
        return Center(
            child: Text(
          'No Files',
              style: Theme.of(context).textTheme.body2,
        ));
      }
      return ListView.separated( // show the list of files
        padding: EdgeInsets.only(left: 12, right: 12),
        separatorBuilder: (context, index) => Divider(
          height: .5,
          color: Color(0xffd3d3d3),
        ),
        itemBuilder: (context, index) => fileItem(files[index]),
        itemCount: files.length,
      );
    });
  }

  imageItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => ImageFullScreen('AttachmentImage_$index',photos[index].imageUrl))),
      child: Hero(
              tag: 'AttachmentImage_$index',
              child:  Image.network(photos[index].imageUrl,fit: BoxFit.cover)),
    );
  }

  fileItem(FileMessage fileMessage) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Icon(
                  Icons.insert_drive_file,
                )),
            Expanded(
              flex: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        fileMessage.fileName,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                fileMessage.timeStamp)),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.file_download,
                      ),
                      onPressed: () => SharedObjects.downloadFile(
                          fileMessage.fileUrl, fileMessage.fileName))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  videoItem(VideoWrapper video) {
    return GestureDetector(
      onTap: () {
        showVideoPlayer(context, video.videoMessage.videoUrl);
      },
      child: Container(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Image.file(
              video.file,
              fit: BoxFit.cover,
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration( // this adds the top and bottom tints to the video thumbnail
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xAA000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0xAA000000),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.play_circle_filled,
            )
          ],
        ),
      ),
    );
  }

  void showVideoPlayer(parentContext, String videoUrl) async {
    await showModalBottomSheetApp(
        context: parentContext,
        builder: (BuildContext bc) {
          return VideoPlayerWidget(videoUrl);
        });
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

}
