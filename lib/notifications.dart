import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamico/size_config.dart';
import 'globals.dart' as globals;

class Notifications extends StatefulWidget {
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String ds;
  var _logs = [
    {
      'name': 'Kishori Tiwari',
      'url':
          'https://varithms.tech/storage/assets/display_picture_defaults/K.png',
      'type': 'Missed Call',
      'color': 'Colors.red'
    },
    {
      'name': 'Rajni Bhardwaj',
      'url':
          'https://varithms.tech/storage/assets/display_picture_defaults/R.png',
      'type': 'Recieved Call',
      'color': 'Colors.green'
    }
  ];
  var _requests = [
    {
      'name': 'Rajni Bhardwaj',
      'url':
          'https://varithms.tech/storage/assets/display_picture_defaults/R.png'
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: SafeArea(
          top: true,
          right: true,
          bottom: true,
          left: true,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: FlatButton(
                        child: Container(
                          margin: EdgeInsets.only(
                              left:
                                  (MediaQuery.of(context).size.width - 170) / 2,
                              right: (MediaQuery.of(context).size.width - 170) /
                                  2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue),
                          height: 60,
                          width: 170,
                          child: Center(
                            child: Text(
                              'Requests',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Livvic'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  top: 0,
                ),
                Positioned(
                  child: _requestsStack(),
                  top: 90,
                  right: 0,
                  left: 0,
                  bottom: 0,
                )
              ],
            ),
          ),
        ));
  }

  Widget _requestsStack() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users/${globals.ds}/requests')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        } else {
          print(snapshot.data.documents.length);
          return ListView(
            children: List.generate(snapshot.data.documents.length, (index) {
              return Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
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
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageUrl: snapshot.data.documents[index]['url'],
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
                        style: TextStyle(fontFamily: 'Livvic', fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey,
                    child: Center(
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.check,
                              color: Colors.grey,
                            ),
                            onPressed: () => _acceptRequest(
                                snapshot.data.documents[index]['uid']),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                        size: 25,
                      ),
                      onPressed: () =>
                          _deleteRequest(snapshot.data.documents[index]['uid']),
                    ),
                  ),
                ],
              );
            }),
          );
        }
      },
    );
  }

  void _deleteRequest(String uidD) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users/${globals.ds}/requests')
        .where('uid', isEqualTo: uidD)
        .get();
    String idD = querySnapshot.docs.single.id;
    await FirebaseFirestore.instance
        .collection('users/${globals.ds}/requests')
        .doc(idD)
        .delete();
  }

  void _acceptRequest(String uidA) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uidA)
        .get();
    String idA = querySnapshot.docs.single.id;
    await _addMeToHim(idA);
    await _addHimToMe(idA);
    await _deleteRequest(uidA);
  }

  void _addMeToHim(String idA) async {
    var me = await FirebaseFirestore.instance
        .collection('users')
        .doc(globals.ds)
        .get();
    print(me['name']);
    Map<String, dynamic> data = new Map<String, dynamic>();
    data.putIfAbsent('name', () => me['name']);
    data.putIfAbsent('id', () => me['id']);
    data.putIfAbsent('uid', () => me['uid']);
    data.putIfAbsent('url', () => me['url']);
    await FirebaseFirestore.instance
        .collection('users/${idA}/friends')
        .add(data);
  }

  void _addHimToMe(String idA) async {
    var me =
        await FirebaseFirestore.instance.collection('users').doc(idA).get();
    print(me['name']);
    Map<String, dynamic> data = new Map<String, dynamic>();
    data.putIfAbsent('name', () => me['name']);
    data.putIfAbsent('id', () => me['id']);
    data.putIfAbsent('uid', () => me['uid']);
    data.putIfAbsent('url', () => me['url']);
    await FirebaseFirestore.instance
        .collection('users/${globals.ds}/friends')
        .add(data);
  }
}
