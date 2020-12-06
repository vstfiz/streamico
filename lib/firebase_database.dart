import 'package:streamico/dashboard.dart';
import 'package:streamico/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'User.dart';

class FirebaseDB {

  static Future<User> getUserDetails(String uid, BuildContext context, String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    print(uid);
    QuerySnapshot querySnapshot =
        await ref.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> ds = querySnapshot.docs;
    if (ds.isEmpty) {
      // Navigator.push(
      //     context, new MaterialPageRoute(builder: (context) => FillDetails()));
    } else {
      DocumentSnapshot document = ds.single;
      globals.mainUser = new User(
          document['name'],
          document['id'],
          email,
          document['url'],
          document['uid']);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DashBoard();
      }));
    }
  }

  static Future<bool> createUser(
      name, mail, uid, id, imageUrl) async {
    globals.mainUser =
        new User(name, id, mail, imageUrl, globals.user.uid);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ref = firestore.collection('users');
    Map<String, dynamic> userData = new Map<String, dynamic>();
    userData.putIfAbsent('name', () => name);
    userData.putIfAbsent('email', () => mail);
    userData.putIfAbsent('id', () => (910000000000+id));
    userData.putIfAbsent('uid', () => globals.user.uid);
    userData.putIfAbsent('url', () => imageUrl);
    ref.add(userData);
  }

  // static Future<List<Question>> getQuestions(String name) async {
  //   // List<Question> ques = new List<Question>();
  //   Firestore firestore = Firestore.instance;
  //   var ref = firestore.collection('algorithms').where('name', isEqualTo: name);
  //   QuerySnapshot querySnapshot = await ref.getDocuments();
  //   List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;
  //   String ds = documentSnapshot.single.documentID;
  //   var refe = await firestore
  //       .collection('algorithms')
  //       .document(ds)
  //       .collection('questions')
  //       .getDocuments();
  //   List<DocumentSnapshot> data = refe.documents;
  //   data.forEach((element) {
  //     // Question q = new Question(element['name'],element['questionNumber'],element['option1'],element['option2'],element['option3'],element['option4']);
  //     // ques.add(q);
  //   });
  //   return ques;
  // }
}
