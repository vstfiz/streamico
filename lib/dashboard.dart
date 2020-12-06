import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:streamico/chat_screen.dart';
import 'package:streamico/firebase_database.dart' as fdb;
import 'package:streamico/globals.dart' as globals;
import 'package:streamico/responsiveui.dart';
import 'package:streamico/searching_service.dart';
import 'package:streamico/settings.dart' as st;
import 'package:streamico/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradient_progress/gradient_progress.dart';
import 'settings.dart';

import 'calling_page.dart';
import 'notifications.dart';

bool isMyAlgorithms = false;

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  bool progressIndicator = false;
  bool myAlgoProgress = false;
  bool isSearching = false;
  double val = 0.0;
  var queryResults = [];
  var tempStorage = [];
  FocusNode focusNode = new FocusNode();
  TextEditingController _channelController = new TextEditingController();
  TextEditingController _addUserIdController = new TextEditingController();
  bool _validateError = false;
  double op = 1.0;
  double op1 = 0.0;
  bool val1;

  startSearch(String query) {
//    print('method chala');
    print(query);

    if (query.length == 0) {
      setState(() {
        queryResults = [];
        tempStorage = [];
      });
    }
    var searchQuery = query.substring(0, 1).toUpperCase() + query.substring(1);
    if (queryResults.length == 0 && searchQuery.length == 1) {
//      print('condition if');
      SearchService().search(searchQuery).then((QuerySnapshot querySnapshot) {
        print(querySnapshot.documents.length);
        for (int i = 0; i < querySnapshot.documents.length; i++) {
          queryResults.add(querySnapshot.documents[i].data);
          print(queryResults.length);
        }
        queryResults.forEach((result) {
          if (result['name'].startsWith(searchQuery)) {
            setState(() {
              tempStorage.add(result);
              print(tempStorage.length);
            });
          }
        });
      });
    } else {
//      print('condition else');
      tempStorage = [];
      queryResults.forEach((result) {
        if (result['name'].startsWith(searchQuery)) {
          setState(() {
            tempStorage.add(result);
            print(tempStorage.length);
          });
        }
      });
    }
  }

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animationController.addListener(() => setState(() {}));
    _animationController.forward();
    getDS();
  }

  void getDS() async {
    var ref = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await ref.where("uid", isEqualTo: globals.user.uid).get();
    globals.ds = querySnapshot.docs.single.id;
  }

  darkValueUpdate() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool temp = sharedPreferences.getBool("darkMode");
    if (temp == null) {
      temp = false;
    }
    sharedPreferences.setBool("darkMode", !temp);
  }

  myAlgoUpdate() async {
    return Timer(new Duration(milliseconds: 1000), hideDialog);
  }

  hideDialog() {
    Navigator.pop(context);
  }

  Future<void> exitDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                "Exit",
                style: TextStyle(fontSize: 30, fontFamily: "Livvic"),
              ),
              content: Text(
                "Do you want to exit ?",
                style: TextStyle(fontSize: 20, fontFamily: "Livvic"),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: Colors.grey[800]),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Livvic",
                        color: Colors.grey[800]),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.blueAccent,
          statusBarBrightness: Brightness.light),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
            if (isSearching) {
              setState(() {
                isSearching = false;
              });
              return Future<bool>.value(false);
            } else {
              exitDialog();
              return Future<bool>.value(false);
            }
          },
          child: Scaffold(
            backgroundColor:
                progressIndicator ? Color(0xFF2E76F1) : Colors.white,
            body: SafeArea(
              bottom: false,
              left: true,
              right: true,
              top: true,
              child: progressIndicator
                  ? Stack(children: <Widget>[
                      Opacity(
                          opacity: 0.5,
                          child: SingleChildScrollView(
                            child: ResponsiveWidget(
                              portraitLayout: _portraitStack(),
                              webLayout: _portraitStack(),
                            ),
                          )
//                SizedBox(
//                  height: MediaQuery
//                      .of(context)
//                      .size
//                      .height,
//                  width: MediaQuery
//                      .of(context)
//                      .size
//                      .width,
//                  child: Container(
//                    decoration: BoxDecoration(
//                        image: DecorationImage(
//                            image: AssetImage('assets/s2.png'),
//                            fit: BoxFit.cover)),
//                  ),
//                ),
                          ),
                      Center(
                        child: _loadingDialog(),
                      )

//              Center(
//                child: Container(
//                  height: 300,
//                  width: 300,
//                  child: AlertDialog(
//                      elevation: 8,
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(15)),
//                      content: Container(
//                        height: 150,
//                        width: 150,
//                        child: LiquidCircularProgressIndicator(
//                          value: val,
//                          // Defaults to 0.5.
//                          valueColor:
//                          AlwaysStoppedAnimation(Color(0xFF2E76F1)Accent),
//                          // Defaults to the current Theme's accentColor.
//                          backgroundColor: Colors.white,
//                          // Defaults to the current Theme's backgroundColor.
//                          borderColor: Color(0xFF2D3E50),
//                          borderWidth: 5.0,
//                          direction: Axis.vertical,
//                          // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
//                          center: Text("Loading..."),
//                        ),
//                      )),
//                ),
//              )
                    ])
                  : SingleChildScrollView(
                      child: ResponsiveWidget(
                      portraitLayout: _portraitStack(),
                      webLayout: _portraitStack(),
                    )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topContainerLandscape(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24.0),
          ),
          color: Color(0xFF2E76F1),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 2.0 * SizeConfig.heightMultiplier,
                  right: 2.0 * SizeConfig.heightMultiplier,
                  top: 1.0 * SizeConfig.heightMultiplier,
                ),
                child: Row(
                  children: <Widget>[
                    _profileImage(context),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1 * SizeConfig.heightMultiplier,
                          ),
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Strings.greetingMessage",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontFamily: "Livvic"),
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.heightMultiplier),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              size: 3 * SizeConfig.heightMultiplier,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1 * SizeConfig.heightMultiplier,
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search here",
                                  ),
                                  style: Theme.of(context).textTheme.display2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.blur_on,
                      color: Colors.white,
                      size: 8 * SizeConfig.imageSizeMultiplier,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 2.0 * SizeConfig.heightMultiplier,
                    bottom: 1.5 * SizeConfig.heightMultiplier),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Curious about an algorithm ?",
                      style: TextStyle(
                        fontFamily: "Livvic",
                        color: Colors.white,
                        fontSize: 3.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 10 * SizeConfig.heightMultiplier,
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * SizeConfig.heightMultiplier),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              3.0 * SizeConfig.heightMultiplier),
                          bottomLeft: Radius.circular(
                              3.0 * SizeConfig.heightMultiplier),
                        ),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 6 * SizeConfig.imageSizeMultiplier,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topContainerPortrait(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1.0,
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.only(top: 2.0 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24.0),
          ),
          color: Color(0xFF2E76F1),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 10,
              top: 10,
              child: Text(
                globals.mainUser.id.toString(),
                style: TextStyle(
                    fontFamily: "Livvic", color: Colors.white, fontSize: 15),
              ),
            ),
            Positioned(
              right: 10,
              child: IconButton(
                  icon: Icon(Icons.notifications),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) {
                      return Notifications();
                    }));
                  }),
            ),
            Container(
              width: 120,
              height: 120,
              margin: EdgeInsets.only(
                  top: 30, left: (MediaQuery.of(context).size.width - 100) / 2),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: CachedNetworkImage(
                imageUrl: globals.mainUser.dp,
                imageBuilder: (context, imageProvider) => Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      shape: BoxShape.circle),
                ),
                placeholder: (context, url) => Center(
                  child: Container(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 170, left: 10, right: 10),
              width: MediaQuery.of(context).size.width - 20,
              height: 30,
              child: Text(
                globals.mainUser.name,
                style: TextStyle(
                    fontFamily: "Livvic", color: Colors.white, fontSize: 30),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 205, left: 10, right: 10),
              width: MediaQuery.of(context).size.width - 20,
              height: 30,
              child: Text(
                globals.mainUser.email,
                style: TextStyle(
                    fontFamily: "Livvic", color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Positioned(
              right: 0,
              top: 220,
              child: Container(
                  width: 80,
                  padding: EdgeInsets.symmetric(
                      vertical: 1 * SizeConfig.heightMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(4.0 * SizeConfig.heightMultiplier),
                      bottomLeft:
                          Radius.circular(4.0 * SizeConfig.heightMultiplier),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return st.Settings();
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 6 * SizeConfig.imageSizeMultiplier,
                    ),
                  )),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(channelName: _channelController.text),
        ));
  }

  Widget _loadingDialog() {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
        content: Container(
            height: 60,
            child: Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2E76F1)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Loading Data...",
                    style: TextStyle(
                        fontFamily: "Livvic", fontSize: 23, letterSpacing: 1),
                  )
                ],
              ),
            )));
  }

  Future<void> _channelDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        TextFormField(
                          controller: _channelController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Channel Name',
                            hintStyle: TextStyle(color: Colors.black45),
                            errorText: _validateError
                                ? 'Channel name is mandatory'
                                : null,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.10,
                              left: MediaQuery.of(context).size.width * 0.5),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onJoin();
                            },
                            child: Text(
                              'Join',
                              style: TextStyle(
                                  fontFamily: 'Livvic',
                                  color: Colors.blue,
                                  fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }

  Future<void> _addUserIdDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: op,
                          child: TextFormField(
                            controller: _addUserIdController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter User\'s Phone',
                              hintStyle: TextStyle(color: Colors.black45),
                              errorText: _validateError
                                  ? 'Phone number is mandatory'
                                  : null,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: op1,
                          child: Row(
                            children: <Widget>[
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2E76F1)),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Sending Request...",
                                style: TextStyle(
                                    fontFamily: "Livvic",
                                    fontSize: 23,
                                    letterSpacing: 1),
                              )
                            ],
                          ),
                        ),
                        Opacity(opacity: op,child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.10,
                              left: MediaQuery.of(context).size.width * 0.35),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontFamily: 'Livvic',
                                  color: Colors.blue,
                                  fontSize: 20),
                            ),
                          ),
                        ),),
                        Opacity(opacity: op,child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.10,
                              left: MediaQuery.of(context).size.width * 0.5),
                          child: FlatButton(
                            onPressed: () async {
                              setState(() {
                                op = 0.0;
                                op1 = 1.0;
                              });
                              if (validate(_addUserIdController.text.trim())) {
                                var ref = await FirebaseFirestore.instance
                                    .collection('users')
                                    .where('id',
                                    isEqualTo: (910000000000 +
                                        int.parse(
                                            _addUserIdController.text.trim())))
                                    .get();
                                bool ans = ref.docs.isNotEmpty;
                                if (ans) {
                                  await _alreadyFriends(910000000000 +
                                      int.parse(_addUserIdController.text.trim()));
                                  if (val1) {
                                    String ds = ref.docs.single.id;
                                    Map<String, String> data =
                                    new Map<String, String>();
                                    data.putIfAbsent(
                                        'name', () => globals.mainUser.name);
                                    data.putIfAbsent(
                                        'uid', () => globals.mainUser.uid);
                                    data.putIfAbsent(
                                        'url', () => globals.mainUser.dp);
                                    await FirebaseFirestore.instance
                                        .collection('users/${ds}/requests')
                                        .add(data);
                                    Navigator.pop(context);
                                    setState(() {
                                      op1 = 0.0;
                                      op = 1.0;
                                    });
                                  } else {
          Fluttertoast.showToast(
          msg: 'Already friends with user',
          toastLength: Toast.LENGTH_LONG);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'User doesn\'t exists',
                                      toastLength: Toast.LENGTH_LONG);
                                  setState(() {
                                    op1 = 0.0;
                                    op = 1.0;
                                  });
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please enter valid user Id',
                                    toastLength: Toast.LENGTH_LONG);
                              }
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(
                                  fontFamily: 'Livvic',
                                  color: Colors.blue,
                                  fontSize: 20),
                            ),
                          ),
                        ),)
                      ],
                    ),
                  )));
        });
  }

  bool validate(String mobile) {
    RegExp regExp = new RegExp(r'(^[6-9][0-9]{9}$)');
    return regExp.hasMatch(mobile);
  }
  
  Future<void> _alreadyFriends(id) async{
    var ref = await FirebaseFirestore.instance.collection('users/${globals.ds}/friends').where('id',isEqualTo: id).get();
    val1 = await ref.docs.isEmpty;
  }

  Widget _portraitStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(3.0 * SizeConfig.heightMultiplier),
            ),
          ),
          constraints: BoxConstraints(
              maxHeight: 40 *
                  (SizeConfig.isMobilePortrait
                      ? SizeConfig.heightMultiplier
                      : SizeConfig.widthMultiplier)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              ResponsiveWidget(
                portraitLayout: _topContainerPortrait(context),
                webLayout: _topContainerLandscape(context),
              ),
            ],
          ),
        ),
        Container(
          constraints:
              BoxConstraints(maxHeight: 100 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            color: Color(0xFFFFF7EC),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Row(
              children: [
                Container(
                    child: Text(
                      "Friends",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Livvic",
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    margin: EdgeInsets.only(left: 20)),
                SizedBox(
                  width: 230,
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.video_call),
                    color: Colors.grey[850],
                    onPressed: () {
                      _channelDialog();
                    },
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.person_add),
                    color: Colors.grey[850],
                    onPressed: () {
                      _addUserIdDialog();
                    },
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 450,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(boxShadow: [
                new BoxShadow(color: Colors.grey, blurRadius: 5),
              ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users/${globals.ds}/friends')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  } else {
                    return ListView(
                      children: List.generate(snapshot.data.documents.length,
                          (index) {
                        return Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 70,
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 40.0,
                                      height: 40.0,
                                      child: FlatButton(
                                        onPressed: () {
// Navigator.push(context,
//     MaterialPageRoute(builder: (context) => UserProfile()));
                                        },
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    imageUrl: snapshot.data.documents[index]
                                        ['url'],
                                    width: 10 * SizeConfig.imageSizeMultiplier,
                                    height: 10 * SizeConfig.imageSizeMultiplier,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    width: 160,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        snapshot.data.documents[index]['name'],
                                        style: TextStyle(
                                            fontFamily: 'Livvic', fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.message),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ChatScreen(
                                            peerId: snapshot
                                                .data.documents[index]['id'],
                                            peerAvatar: snapshot
                                                .data.documents[index]['url'],
                                            peerName: snapshot
                                                .data.documents[index]['name'],
                                          );
                                        }));
                                      }),
                                ],
                              ),
                            ),
                            Positioned(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 140,
                                child: Divider(
                                  thickness: 1,
                                  height: 10,
                                  color: Colors.grey[850],
                                ),
                              ),
                              top: 65,
                              right: 50,
                              left: 50,
                            )
                          ],
                        );
                      }),
                    );
                  }
                },
              ),
            )
          ]),
        ),
      ],
    );
  }

  Widget _profileImage(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => Container(
        width: 50.0,
        height: 50.0,
        child: FlatButton(
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => UserProfile()));
          },
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: globals.mainUser.dp,
      width: 10 * SizeConfig.imageSizeMultiplier,
      height: 10 * SizeConfig.imageSizeMultiplier,
    );
  }

// Widget _algorithmTypeCards(BuildContext context) {
//   return CarouselSlider(
//     options: CarouselOptions(
//         height: 295.0,
//         viewportFraction: 0.95,
//         enableInfiniteScroll: true,
//         enlargeCenterPage: true,
//         autoPlay: true,
//         autoPlayAnimationDuration: new Duration(milliseconds: 1000)),
//     items: globals.algoTypeList.map((i) {
//       return Builder(
//         builder: (BuildContext context) {
//           return FlatButton(
//             onPressed: () {
//               globals.selectedAlgoTypeName = i.name;
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return AlgorithmsList();
//                   },
//                 ),
//               );
//             },
//             child: Container(
//               width: 360,
//               margin: EdgeInsets.symmetric(
//                   horizontal: 1 * SizeConfig.widthMultiplier),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(3 * SizeConfig.heightMultiplier),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Expanded(
//                     flex: 8,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(3 * SizeConfig.heightMultiplier),
//                       ),
//                       child: AspectRatio(
//                           aspectRatio: 3,
//                           child: CachedNetworkImage(
//                             imageUrl: i.imageUrl,
//                             placeholder: (context, url) =>
//                                 Center(
//                                   child: SizedBox(
//                                     height: 30,
//                                     width: 30,
//                                     child: Card(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                               5)),
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                   ),
//                                 ),
//                             errorWidget: (context, url, error) =>
//                                 Icon(Icons.error),
//                           )),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Container(
//                     width: 360,
//                     child: Text(
//                       i.name,
//                       style: TextStyle(
//                           fontFamily: "Livvic",
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: 360,
//                     child: Text(
//                       i.noOfAlgorithms + " Courses",
//                       style: TextStyle(
//                           fontFamily: "Livvic",
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }).toList(),
//   );
// }

//   Widget _algorithmCards(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//           height: 295.0,
//           viewportFraction: 0.95,
//           enableInfiniteScroll: true,
//           enlargeCenterPage: true,
//           autoPlay: true,
//           autoPlayAnimationDuration: new Duration(milliseconds: 300)),
//       items: globals.algoListForDashboard.map((i) {
//         return Builder(
//           builder: (BuildContext context) {
//             return FlatButton(
//               onPressed: () {
//                 globals.selectedAlgoTypeName = i.name;
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return AlgorithmsList();
//                     },
//                   ),
//                 );
//               },
//               child: Container(
// //                width: 360,
//                 margin: EdgeInsets.symmetric(
//                     horizontal: 1 * SizeConfig.widthMultiplier),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(3 * SizeConfig.heightMultiplier),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       flex: 8,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(3 * SizeConfig.heightMultiplier),
//                         ),
//                         child: AspectRatio(
//                             aspectRatio: 3,
//                             child: CachedNetworkImage(
//                               imageUrl: i.imageUrl,
//                               placeholder: (context, url) =>
//                                   Center(
//                                     child: SizedBox(
//                                       height: 30,
//                                       width: 30,
//                                       child: Card(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 5)),
//                                         child: CircularProgressIndicator(),
//                                       ),
//                                     ),
//                                   ),
//                               errorWidget: (context, url, error) =>
//                                   Icon(Icons.error),
//                             )),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Container(
//                       width: 360,
//                       child: Text(
//                         i.name,
//                         style: TextStyle(
//                             fontFamily: "Livvic",
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
}
