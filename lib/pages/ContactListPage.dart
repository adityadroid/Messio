import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/contacts/Bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Decorations.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/widgets/BottomSheetFixed.dart';
import 'package:messio/widgets/ContactRowWidget.dart';
import 'package:messio/widgets/GradientFab.dart';
import 'package:messio/widgets/GradientSnackBar.dart';
import 'package:messio/widgets/QuickScrollBar.dart';

class ContactListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactListPageState();

  const ContactListPage();
}

class _ContactListPageState extends State<ContactListPage>
    with TickerProviderStateMixin {
  ContactsBloc contactsBloc;
  ScrollController scrollController;
  final TextEditingController usernameController = TextEditingController();
  List<Contact> contacts;
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    contacts = List();
    contactsBloc = BlocProvider.of<ContactsBloc>(context);
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
    animationController.forward();
    contactsBloc.dispatch(FetchContactsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocListener<ContactsBloc, ContactsState>(
              listener: (bc, state) {
                print(state);
                if (state is AddContactSuccessState) {
                  Navigator.pop(context);
                  GradientSnackBar.showMessage(context, "Contact Added Successfully!");
                } else if (state is ErrorState) {
                 GradientSnackBar.showError(context, state.exception.errorMessage());
                } else if (state is AddContactFailedState) {
                  Navigator.pop(context);
                  GradientSnackBar.showError(context, state.exception.errorMessage());
                }
              },
              child: Stack(
                children: <Widget>[
                  CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        SliverAppBar(
                          expandedHeight: 180.0,
                          pinned: true,
                          elevation: 0,
                          centerTitle: true,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text("Contacts", style: Theme.of(context).textTheme.title),
                          ),
                        ),
                        BlocBuilder<ContactsBloc, ContactsState>(
                            builder: (context, state) {
                          if (state is FetchingContactsState) {
                            return SliverToBoxAdapter(
                              child: SizedBox(
                                height: (MediaQuery.of(context).size.height),
                                child: Center(child: CircularProgressIndicator()),
                              ),
                            );
                          }

                          if (state is FetchedContactsState)
                            contacts = state.contacts;

                          return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return ContactRowWidget(contact: contacts[index]);
                            }, childCount: contacts.length),
                          );
                        })
                      ]),
                  Container(
                    margin: EdgeInsets.only(top: 190),
                    child: BlocBuilder<ContactsBloc, ContactsState>(
                        builder: (context, state) {
                      return QuickScrollBar(
                        nameList: contacts,
                        scrollController: scrollController,
                      );
                    }),
                  ),
                ],
              ),
            ),
        floatingActionButton: GradientFab(
          child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
          animation: animation,
          vsync: this,
          onPressed: () => showAddContactsBottomSheet(context),
        ),
      ),
    );
  }

  //scroll listener for checking scroll direction and hide/show fab
  scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  void showAddContactsBottomSheet(parentContext) async {
    await showModalBottomSheetApp(
        context: context,
        builder: (BuildContext bc) {
          return BlocBuilder<ContactsBloc, ContactsState>(
              builder: (context,state){
             return  Card(
               margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.only(topLeft: Radius.circular(40.5),topRight:Radius.circular(40.0))),
                    child: Container(
                      decoration: BoxDecoration(
                          color:Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0))),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Container(constraints: BoxConstraints(minHeight: 100),child: Image.asset(Assets.social))),
                          Container(
                            margin: EdgeInsets.only(top: 40),
                            child: Text(
                              'Add by Username',
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
                            child: TextField(
                              controller: usernameController,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subhead,
                              decoration: Decorations.getInputDecoration(
                                  hint: '@username', context: parentContext),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                child: BlocBuilder<ContactsBloc, ContactsState>(
                                    builder: (context, state) {
                                  return GradientFab(
                                    elevation: 0.0,
                                    child: getButtonChild(state),
                                    onPressed: () {
                                      contactsBloc.dispatch(AddContactEvent(
                                          username: usernameController.text));
                                    },
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
              );
              });
        });
  }

  getButtonChild(ContactsState state) {
    if (state is AddContactSuccessState || state is ErrorState) {
      return Icon(Icons.check, color: Theme.of(context).primaryColor);
    } else if (state is AddContactProgressState) {
      return SizedBox(
        height: 9,
        width: 9,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      return Icon(Icons.done, color: Theme.of(context).primaryColor);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
