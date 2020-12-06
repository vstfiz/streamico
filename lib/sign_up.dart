import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dashboard.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool op1 = true;
  bool op2 = false;
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _cnfPasswordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  RegExp phone = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  String defaultImageUrl =
      "https://varithms.tech/storage/assets/display_picture_defaults/";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          // _showExitAlert();
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              op1
                  ? Screen1(context)
                  : op2 ? Screen2(context) : Screen3(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget Screen1(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFFFFAFF),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 100, left: 10, right: 10),
                width: MediaQuery.of(context).size.width - 20,
                height: 300,
                child: Image.asset('assets/images/login_screen1.jpg'),
              ),
              Container(
                margin: EdgeInsets.only(top: 500, right: 30, left: 30),
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontFamily: 'Livvic', color: Colors.grey),
                    hintText: 'First Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  style: TextStyle(color: Colors.black, fontFamily: "Livvic"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 580, right: 30, left: 30),
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontFamily: 'Livvic', color: Colors.grey),
                    hintText: 'Last Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  style: TextStyle(color: Colors.black, fontFamily: "Livvic"),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 650, right: 30, left: 30),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 60,
                  color: Color(0xFF2E76F1),
                  child: FlatButton(
                    onPressed: () {
                      if (_firstNameController.text != '' &&
                          _firstNameController.text != null) {
                        if (_lastNameController.text != '' &&
                            _lastNameController.text != null) {
                          setState(() {
                            op1 = false;
                            op2 = true;
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Last Name can\'t be empty',
                              toastLength: Toast.LENGTH_LONG);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'First Name can\'t be empty',
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                            fontFamily: "Livvic", color: Colors.white),
                      ),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 30),
                  height: 50,
                  width: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'OR',
                      style:
                          TextStyle(fontFamily: "Livvic", color: Colors.black),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 120),
                  height: 50,
                  width: 50,
                  color: Colors.white,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: Image.asset('assets/google.png').image,
                      )),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 230),
                  height: 50,
                  width: 50,
                  color: Colors.blue,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: Image.asset('assets/facebook.png').image,
                      )),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(top: 790, right: 30, left: 30),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Login();
                    }));
                  },
                  child: Text(
                    'Already have an account? Login here.',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: 'Livvic',
                        fontSize: 23),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget Screen2(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFFFFAFF),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                width: MediaQuery.of(context).size.width - 20,
                height: 300,
                child: Image.asset('assets/images/login_screen2.jpg'),
              ),
              Container(
                margin: EdgeInsets.only(top: 400, right: 30, left: 30),
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontFamily: 'Livvic', color: Colors.grey),
                    hintText: 'E-mail',
                    prefixIcon: Icon(Icons.person),
                  ),
                  style: TextStyle(color: Colors.black, fontFamily: "Livvic"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 470, right: 30, left: 30),
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  controller: _passwordController,
                  autofocus: false,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontFamily: 'Livvic', color: Colors.grey),
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  style: TextStyle(color: Colors.black, fontFamily: "Livvic"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 540, right: 30, left: 30),
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  controller: _cnfPasswordController,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontFamily: 'Livvic', color: Colors.grey),
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  style: TextStyle(color: Colors.black, fontFamily: "Livvic"),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 650, right: 30, left: 30),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 60,
                  color: Color(0xFF2E76F1),
                  child: FlatButton(
                    onPressed: () {
                      if (EmailValidator.validate(_emailController.text)) {
                        if (_passwordController.text != '' &&
                            _passwordController.text != null) {
                          if (_cnfPasswordController.text != '' &&
                              _cnfPasswordController.text != null) {
                            if (_passwordController.text ==
                                _cnfPasswordController.text) {
                              setState(() {
                                op2 = false;
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Passwords don\'t match',
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Last Name can\'t be empty',
                                toastLength: Toast.LENGTH_LONG);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'First Name can\'t be empty',
                              toastLength: Toast.LENGTH_LONG);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please provide a valid e-mail.',
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                            fontFamily: "Livvic", color: Colors.white),
                      ),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 30),
                  height: 50,
                  width: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'OR',
                      style:
                          TextStyle(fontFamily: "Livvic", color: Colors.black),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 120),
                  height: 50,
                  width: 50,
                  color: Colors.white,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: Image.asset('assets/google.png').image,
                      )),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 230),
                  height: 50,
                  width: 50,
                  color: Colors.blue,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: Image.asset('assets/facebook.png').image,
                      )),
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget Screen3(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFFFFAFF),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                width: MediaQuery.of(context).size.width - 20,
                height: 300,
                child: Image.asset('assets/images/login_screen3.jpg'),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 350,
                    right: (MediaQuery.of(context).size.width / 2) - 60,
                    left: (MediaQuery.of(context).size.width / 2) - 60),
                height: 120,
                width: 120,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => Container(
                    height: 130,
                    width: 130,
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
                  imageUrl: defaultImageUrl + 'V' + ".png",
                  width: 120,
                  height: 120,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 500, right: 30, left: 60),
                  height: 60,
                  width: 60,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Icon(Icons.camera_alt),
                  )),
              Container(
                  margin: EdgeInsets.only(
                      top: 500,
                      right: 30,
                      left: MediaQuery.of(context).size.width - 110),
                  height: 60,
                  width: 60,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Icon(Icons.add),
                  )),
              Container(
                margin: EdgeInsets.only(top: 580, right: 30, left: 30),
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontFamily: 'Livvic', color: Colors.grey),
                    hintText: 'Mobile',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  style: TextStyle(color: Colors.black, fontFamily: "Livvic"),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 650, right: 30, left: 30),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 60,
                  color: Color(0xFF2E76F1),
                  child: FlatButton(
                    onPressed: () {
                      if (_phoneController.text != '' &&
                          _phoneController.text != null) {
                        if (phone.hasMatch(_phoneController.text)) {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context) {
                            return DashBoard();
                          }));
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Last Name can\'t be empty',
                              toastLength: Toast.LENGTH_LONG);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'First Name can\'t be empty',
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Finish',
                        style: TextStyle(
                            fontFamily: "Livvic", color: Colors.white),
                      ),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 30),
                  height: 50,
                  width: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'OR',
                      style:
                          TextStyle(fontFamily: "Livvic", color: Colors.black),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 120),
                  height: 50,
                  width: 50,
                  color: Colors.white,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: Image.asset('assets/google.png').image,
                      )),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 720, right: 30, left: 230),
                  height: 50,
                  width: 50,
                  color: Colors.blue,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: Image.asset('assets/facebook.png').image,
                      )),
                    ),
                  )),
            ],
          ),
        ));
  }
}
