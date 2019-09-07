import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/widgets/ContactRowWidget.dart';

class ContactListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactListPageState();

  const ContactListPage();
}

class _ContactListPageState extends State<ContactListPage> {
  bool isAppBarExpanded = false;
  double width = 0;
  ScrollController scrollController; // To control scrolling
  @override
  void initState() {
    scrollController = ScrollController()..addListener(() => setState(() {
      if(scrollController.offset<152){
      width = scrollController.offset/2.3;
      print(width);
      }
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers:<Widget>[
            SliverAppBar(
              expandedHeight: 120.0,
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              elevation: 0,
              titleSpacing: 0.0,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {

                  return FlexibleSpaceBar(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Contacts", style: Styles.appBarTitle),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
          SliverList(
            delegate:SliverChildBuilderDelegate(
                    (context,index){
                  return ContactRowWidget();
                },
                childCount: 30
            ),
          )
          ])
    );

  }

//  bool get isExpanded {
//    return scrollController.hasClients
//        && scrollController.offset > 120;
//  }
}
