import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/attachments/attachments_bloc.dart';
import 'package:messio/blocs/chats/bloc.dart';
import 'package:messio/blocs/config/bloc.dart';
import 'package:messio/blocs/contacts/bloc.dart';
import 'package:messio/blocs/home/bloc.dart';
import 'package:messio/config/constants.dart';
import 'package:messio/config/themes.dart';
import 'package:messio/pages/home_page.dart';
import 'package:messio/repositories/authentication_repository.dart';
import 'package:messio/repositories/chat_repository.dart';
import 'package:messio/repositories/storage_repository.dart';
import 'package:messio/repositories/user_data_repository.dart';
import 'package:messio/utils/shared_objects.dart';
import 'package:path_provider/path_provider.dart';
import 'blocs/authentication/bloc.dart';
import 'pages/register_page.dart';
void main() async {
  //create instances of the repositories to supply them to the app
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();
  final ChatRepository chatRepository = ChatRepository();
  SharedObjects.prefs = await CachedSharedPreferences.getInstance();
  Constants.cacheDirPath = (await getTemporaryDirectory()).path;
  Constants.downloadsDirPath =
      (await DownloadsPathProvider.downloadsDirectory).path;
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            authenticationRepository: authRepository,
            userDataRepository: userDataRepository,
            storageRepository: storageRepository)
          ..add(AppLaunched()),
      ),
      BlocProvider<ContactsBloc>(
        create: (context) => ContactsBloc(
            userDataRepository: userDataRepository,
            chatRepository: chatRepository),
      ),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
            userDataRepository: userDataRepository,
            storageRepository: storageRepository,
            chatRepository: chatRepository),
      ),
      BlocProvider<AttachmentsBloc>(
        create: (context) => AttachmentsBloc(chatRepository: chatRepository),
      ),
      BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(chatRepository: chatRepository),
      ),
      BlocProvider<ConfigBloc>(
        create: (context) => ConfigBloc(storageRepository: storageRepository,userDataRepository: userDataRepository),
      )
    ],
    child: Messio(),
  ));
}



// ignore: must_be_immutable
class Messio extends StatefulWidget {
  @override
  _MessioState createState() => _MessioState();
}

class _MessioState extends State<Messio> {
  ThemeData theme;
  Key key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(builder: (context, state) {
      if (state is UnConfigState) {
        theme = SharedObjects.prefs.getBool(Constants.configDarkMode)
            ? Themes.dark
            : Themes.light;
      }
      if(state is RestartedAppState){
        key = UniqueKey();
      }
      if (state is ConfigChangeState && state.key == Constants.configDarkMode) {
        theme = state.value ? Themes.dark : Themes.light;
      }
      return MaterialApp(
        title: 'Messio',
        theme: theme,
        key: key,
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is UnAuthenticated) {
              return RegisterPage();
            } else if (state is ProfileUpdated) {
              if(SharedObjects.prefs.getBool(Constants.configMessagePaging))
                BlocProvider.of<ChatBloc>(context).add(FetchChatListEvent());
              return HomePage();
            } else {
              return RegisterPage();
            }
          },
        ),
      );
    });
  }
}
