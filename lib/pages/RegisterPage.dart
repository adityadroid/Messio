import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/pages/ConversationPageSlide.dart';
import 'package:messio/widgets/CircleIndicator.dart';
import 'package:messio/widgets/NumberPicker.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;
  int age = 18;
  var isKeyboardOpen =
      false; //this variable keeps track of the keyboard, when its shown and when its hidden

  PageController pageController =
      PageController(); // this is the controller of the page. This is used to navigate back and forth between the pages

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  //Fields related to animating the layout and pushing widgets up when the focus is on the username field
  AnimationController usernameFieldAnimationController;
  Animation profilePicHeightAnimation, usernameAnimation, ageAnimation;
  FocusNode usernameFocusNode = FocusNode();


  @override
  void initState() {
    initApp();
    super.initState();
  }

  void initApp() async {
      WidgetsBinding.instance.addObserver(this);
    usernameFieldAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    profilePicHeightAnimation =
        Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    usernameAnimation =
        Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    ageAnimation =
        Tween(begin: 80.0, end: 10.0).animate(usernameFieldAnimationController)
          ..addListener(() {
            setState(() {});
          });
    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        usernameFieldAnimationController.forward();
      } else {
        usernameFieldAnimationController.reverse();
      }
    });
    pageController.addListener(() {
      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop, //user to override the back button press
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          //  avoids the bottom overflow warning when keyboard is shown
          body: SafeArea(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: begin, end: end, colors: [
                    Palette.gradientStartColor,
                    Palette.gradientEndColor
                  ])),
                  child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                             PageView(
                                controller: pageController,
                                physics: NeverScrollableScrollPhysics(),
                                onPageChanged: (int page) =>
                                    updatePageState(page),
                                children: <Widget>[
                                  buildPageOne(),
                                  buildPageTwo(),

                                ]),
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < 2; i++)
                                CircleIndicator(i == currentPage),
                            ],
                          ),
                        ),
                        AnimatedOpacity(
                            opacity: currentPage == 1 ? 1.0 : 0.0, //shows only on page 1
                            duration: Duration(milliseconds: 500),
                            child: Container(
                                margin: EdgeInsets.only(right: 20, bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    FloatingActionButton(
                                      onPressed: () => navigateToHome(),
                                      elevation: 0,
                                      backgroundColor: Palette.primaryColor,
                                      child: Icon(
                                        Icons.done,
                                        color: Palette.accentColor,
                                      ),
                                    )
                                  ],
                                )))
                      ]))),
        ));
  }

  buildPageOne() {
    return Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 250),
              child: Image.asset(Assets.app_icon_fg, height: 100)),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Text('Messio Messenger',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22))),
          Container(
              margin: EdgeInsets.only(top: 100),

                  child: FlatButton.icon(
                      onPressed: () => updatePageState(1),
                      color: Colors.transparent,
                      icon: Image.asset(
                        Assets.google_button,
                        height: 25,
                      ),
                      label: Text(
                        'Sign In with Google',
                        style: TextStyle(
                            color: Palette.primaryTextColorLight,
                            fontWeight: FontWeight.w800),
                      )))
        ],

    );
  }

  buildPageTwo() {
    return InkWell(
        // to dismiss the keyboard when the user tabs out of the TextField
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: profilePicHeightAnimation.value),
                   CircleAvatar(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 15,
                    ),
                    Text(
                      'Set Profile Picture',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                backgroundImage: Image.asset(Assets.user).image,
                radius: 60,
              ),
              SizedBox(
                height: ageAnimation.value,
              ),
              Text(
                'How old are you?',
                style: Styles.questionLight,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  NumberPicker.horizontal(
                      initialValue: age,
                      minValue: 15,
                      maxValue: 100,
                      highlightSelectedValue: true,
                      onChanged: (num value) {
                        setState(() {
                          age = value;
                        });
                        //   print(age);
                      }),
                  Text('Years', style: Styles.textLight)
                ],
              ),
              SizedBox(
                height: usernameAnimation.value,
              ),
             Text(
                  'Choose a username',
                  style: Styles.questionLight,
                ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 120,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: Styles.subHeadingLight,
                    focusNode: usernameFocusNode,
                    decoration: InputDecoration(
                      hintText: '@username',
                      hintStyle: Styles.hintTextLight,
                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Palette.primaryColor, width: 0.1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Palette.primaryColor, width: 0.1),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }

  updatePageState(index) {
    if (index == 1)
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);

    setState(() {
      currentPage = index;
    });
  }

  Future<bool> onWillPop() async {
    if (currentPage == 1) {
      //go to first page if currently on second page
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    usernameFieldAnimationController.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  ///
  /// This routine is invoked when the window metrics have changed.
  ///
  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (isKeyboardOpen) {
        onKeyboardChanged(false);
      }
      isKeyboardOpen = false;
    } else {
      isKeyboardOpen = true;
      onKeyboardChanged(true);
    }
  }

  onKeyboardChanged(bool isVisible) {
    if (!isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
      usernameFieldAnimationController.reverse();
    }
  }

  navigateToHome() {
    Navigator.push(
      context,
      SlideLeftRoute(page: ConversationPageSlide()),
    );
  }
}
