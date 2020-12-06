import 'dart:async';

// import 'package:streamico/dashboard.dart';
import 'package:streamico/firebase_database.dart' as fdb;
import 'package:email_validator/email_validator.dart';
import 'package:streamico/globals.dart' as globals;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'fire_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSignUp = false;
  bool isPhone = false;
  bool isProgress = false;
  bool loginProgress = false;
  bool otpSent = false;
  bool forgotPassword = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  Future<void> wait() async {
    return Timer(new Duration(milliseconds: 1000), () {
      setState(() {
        isProgress = false;
      });
    });
  }

  Future<void> exitDialog() {
    return showDialog<void>(
        context: context,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              title: Text(
                "Exit", style: TextStyle(fontSize: 30, fontFamily: "Livvic"),),
              content: Text("Do you want to exit ?",
                style: TextStyle(fontSize: 20, fontFamily: "Livvic"),),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(fontSize: 20,
                      fontFamily: "Livvic",
                      color: Colors.grey[800]),),
                ),
                FlatButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text("Exit", style: TextStyle(fontSize: 20,
                      fontFamily: "Livvic",
                      color: Colors.grey[800]),),
                )
              ],
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exitDialog();
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Screen1(context),
        )
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintStyle:
                    TextStyle(fontFamily: 'Livvic', color: Colors.grey),
                    hintText: 'E-mail',
                    prefixIcon: Icon(Icons.mail),
                  ),
                  style: TextStyle(color: Colors.black, fontFamily: "Livvic"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 580, right: 30, left: 30),
                height: 50,
                width: MediaQuery.of(context).size.width - 60,
                child: TextField(
                  obscuringCharacter: '*',
                  obscureText: true,
                  controller: _passwordController,
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
                  margin: EdgeInsets.only(top: 650, right: 30, left: 30),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 60,
                  color: Color(0xFF2E76F1),
                  child: FlatButton(
                    onPressed: () async {
                      if (EmailValidator.validate(_emailController.text)) {
                        if (_passwordController.text != '' &&
                            _passwordController.text != null) {

                          User user = await signInWithEmail(_emailController.text,_passwordController.text);
                          globals.user.uid = user.uid;
                          globals.user.email = user.email;
                          await fdb.FirebaseDB.getUserDetails(user.uid,context,user.email);
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Password can\'t be empty',
                              toastLength: Toast.LENGTH_LONG);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please Enter a valid E-mail',
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontFamily: "Livvic", color: Colors.white),
                      ),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 780, right: 30, left: 30),
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

  Widget tempP(){
    return Container(
      color: Colors.blue,
      height: 300,
      width: 200,
    );
  }

//   Widget PortraitStack(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Stack(
//         children: <Widget>[
//           Opacity(
//             opacity: 0.1,
//             child: Container(
//               height: MediaQuery
//                   .of(context)
//                   .size
//                   .height,
//               width: MediaQuery
//                   .of(context)
//                   .size
//                   .width,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("assets/back_login.png"),
//                       fit: BoxFit.contain)),
//             ),
//           ),
//           Positioned(
//             top: 150,
//             left: 30,
//             right: 30,
//             child: Container(
//               height: 300,
//               width: 300,
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25)),
//                 elevation: 15,
//                 child: isProgress
//                     ? _inProgress()
//                     : forgotPassword
//                     ? _forgotPassword()
//                     : isPhone
//                     ? _phoneLogin()
//                     : isSignUp ? _signUp() : _login(),
//               ),
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(left: 30, top: 500),
//                 child: Divider(
//                   thickness: 2,
//                   color: Colors.black,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(left: 15, top: 500),
//                 child: Text(
//                   "OR",
//                   style: TextStyle(fontSize: 25),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(left: 15, top: 500),
//                 child: Divider(
//                   thickness: 2,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             top: 580,
//             left: 50,
//             right: 50,
//             child: Container(
// //            color: Colors.white,
//               width: 260,
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey,
//                         borderRadius: BorderRadius.circular(10)),
//                     child: FlatButton(
//                       onPressed: () {
//                         globals.isEmailLogin = true;
//                         signInWithGoogle().whenComplete(() {
//                           fdb.FirebaseDB.getUserDetails(user.uid, context);
//                         });
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 30,
//                             height: 30,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage('assets/google.png'))),
//                           ),
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Text(
//                             "Sign  In  With  Google",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: "Livvic",
//                                 fontSize: 22),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Color(0xFF3B5998),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: FlatButton(
//                       onPressed: () {
//                         signInWithFacebook(context).whenComplete(() async {
//                           await fdb.FirebaseDB.getUserDetails(
//                               user.uid, context);
//                         });
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 30,
//                             height: 30,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage('assets/facebook.png'))),
//                           ),
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Text(
//                             "Sign  In  With  Facebook",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: "Livvic",
//                                 fontSize: 22),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Color(0xFF02BD7E),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: FlatButton(
//                       onPressed: () {
//                         setState(() {
//                           isProgress = true;
//                         });
//                         wait().whenComplete(() {
//                           isPhone = true;
//                           isSignUp = false;
//                           forgotPassword = false;
//                         });
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 30,
//                             height: 30,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage('assets/phone.png'))),
//                           ),
//                           SizedBox(
//                             width: 30,
//                           ),
//                           Text(
//                             "Sign  In  With  Phone",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: "Livvic",
//                                 fontSize: 22),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//               bottom: 30,
//               left: 10,
//               right: 10,
//               child: SizedBox(
//                 height: 80,
//                 width: 340,
//                 child: Column(
//                   children: <Widget>[
//                     isSignUp || forgotPassword
//                         ? SizedBox(
//                       height: 30,
//                     )
//                         : Text(
//                       "Don't have an account?",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontFamily: "Livvic",
//                           fontSize: 25),
//                     ),
//                     isSignUp || forgotPassword
//                         ? Container(
//                       width: 250,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Color(0xFF2D3E50),
//                       ),
//                       child: FlatButton(
//                         onPressed: () {
//                           setState(() {
//                             isProgress = true;
//                           });
//                           wait();
//                           setState(() {
//                             isSignUp = false;
//                             isPhone = false;
//                             forgotPassword = false;
//                           });
//                         },
//                         child: Text(
//                           "Sign In with E-mail",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: "Livvic",
//                               fontSize: 25),
//                         ),
//                       ),
//                     )
//                         : FlatButton(
//                       onPressed: () {
//                         setState(() {
//                           isProgress = true;
//                         });
//                         wait();
//                         setState(() {
//                           isSignUp = true;
//                           isPhone = false;
//                           forgotPassword = false;
//                         });
//                       },
//                       child: Text(
//                         "Sign Up",
//                         style: TextStyle(
//                             color: Colors.blueAccent,
//                             fontFamily: "Livvic",
//                             fontSize: 25),
//                       ),
//                     )
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }

  // Widget _phoneLogin() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: otpSent ? 20 : 60, horizontal: 15),
  //     child: Column(
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             Container(
  //               child: CountryCodePicker(
  //                 initialSelection: 'IN',
  //                 favorite: ['+91', 'IN'],
  //               ),
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             Stack(
  //               children: <Widget>[
  //                 Container(
  //                   width: 210,
  //                   child: Card(
  //                     elevation: 10,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(25)),
  //                     child: TextField(
  //                       enabled: !otpSent,
  //                       style: TextStyle(fontFamily: "Livvic", fontSize: 25),
  //                       controller: globals.mobileController,
  //                       keyboardType: TextInputType.phone,
  //                       decoration: InputDecoration(
  //                         hintText: "Phone",
  //                         prefixIcon: Icon(Icons.phone),
  //                         contentPadding: EdgeInsets.only(right: 5.0, top: 8),
  //                         border: InputBorder.none,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 otpSent
  //                     ? Positioned(
  //                   right: 0,
  //                   child: IconButton(
  //                     icon: Icon(Icons.edit),
  //                     onPressed: () {
  //                       setState(() {
  //                         otpSent = false;
  //                       });
  //                     },
  //                   ),
  //                 )
  //                     : SizedBox()
  //               ],
  //             )
  //           ],
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         otpSent
  //             ? Container(
  //           width: 290,
  //           child: Card(
  //             elevation: 10,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(25)),
  //             child: TextField(
  //               obscureText: true,
  //               controller: globals.otpController,
  //               keyboardType: TextInputType.phone,
  //               style: TextStyle(fontFamily: "Livvic", fontSize: 25),
  //               decoration: InputDecoration(
  //                   hintText: "4-Digit OTP",
  //                   prefixIcon: Icon(Icons.vpn_key),
  //                   contentPadding: EdgeInsets.only(right: 5.0, top: 8),
  //                   border: InputBorder.none),
  //             ),
  //           ),
  //         )
  //             : SizedBox(),
  //         otpSent
  //             ? Container(
  //           margin: EdgeInsets.only(left: 150),
  //           child: FlatButton(
  //             child: Text(
  //               "Resend OTP",
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   fontFamily: "Livvic",
  //                   color: Colors.blue),
  //             ),
  //           ),
  //         )
  //             : SizedBox(),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Container(
  //           width: 150,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(15), color: Colors.blue),
  //           child: FlatButton(
  //             onPressed: () {
  //               if (otpSent) {
  //                 globals.isOtpLogin = true;
  //                 Navigator.push(
  //                     context,
  //                     new MaterialPageRoute(
  //                         builder: (context) => FillDetails()));
  //               } else {
  //                 setState(() {
  //                   otpSent = true;
  //                 });
  //               }
  //             },
  //             child: otpSent
  //                 ? Text(
  //               "Login",
  //               style: TextStyle(
  //                   fontFamily: "Livvic",
  //                   fontSize: 22,
  //                   color: Colors.white),
  //             )
  //                 : Text(
  //               "Send OTP",
  //               style: TextStyle(
  //                   fontFamily: "Livvic",
  //                   fontSize: 22,
  //                   color: Colors.white),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _signUp() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           width: 290,
  //           child: Card(
  //             elevation: 10,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(25)),
  //             child: TextField(
  //               style: TextStyle(fontFamily: "Livvic", fontSize: 25),
  //               controller: globals.usernameController,
  //               decoration: InputDecoration(
  //                   hintText: "E-mail",
  //                   prefixIcon: Icon(Icons.people),
  //                   contentPadding: EdgeInsets.only(right: 5.0, top: 8),
  //                   border: InputBorder.none),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Container(
  //           width: 290,
  //           child: Card(
  //             elevation: 10,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(25)),
  //             child: TextField(
  //               obscureText: true,
  //               controller: globals.passwordController,
  //               style: TextStyle(fontFamily: "Livvic", fontSize: 25),
  //               decoration: InputDecoration(
  //                   hintText: "Password",
  //                   prefixIcon: Icon(Icons.lock),
  //                   contentPadding: EdgeInsets.only(right: 5.0, top: 8),
  //                   border: InputBorder.none),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Container(
  //           width: 290,
  //           child: Card(
  //             elevation: 10,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(25)),
  //             child: TextField(
  //               obscureText: true,
  //               controller: globals.cnfPasswordController,
  //               style: TextStyle(fontFamily: "Livvic", fontSize: 25),
  //               decoration: InputDecoration(
  //                   hintText: "Confirm Password",
  //                   prefixIcon: Icon(Icons.lock),
  //                   contentPadding: EdgeInsets.only(right: 5.0, top: 8),
  //                   border: InputBorder.none),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 15,
  //         ),
  //         loginProgress ? _inProgress() : Container(
  //           width: 100,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(25), color: Colors.blue),
  //           child: FlatButton(
  //             onPressed: () async {
  //               globals.isEmailLogin = true;
  //               setState(() {
  //                 loginProgress = true;
  //               });
  //               print("fgghh value :- " +
  //                   globals.usernameController.text.toString());
  //               FirebaseUser nUser = await signUpWithEmail(
  //                   globals.usernameController.text.toString(),
  //                   globals.passwordController.text.toString());
  //               print("login uid : " + user.uid);
  //               Navigator.push(context,
  //                   new MaterialPageRoute(builder: (context) => FillDetails()));
  //             },
  //             child: Text(
  //               "Sign Up",
  //               style: TextStyle(
  //                   fontFamily: "Livvic", fontSize: 22, color: Colors.white),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _forgotPassword() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           width: 290,
  //           child: Card(
  //             elevation: 10,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(25)),
  //             child: TextField(
  //               style: TextStyle(fontFamily: "Livvic", fontSize: 25),
  //               controller: globals.usernameController,
  //               decoration: InputDecoration(
  //                   hintText: "E-mail",
  //                   prefixIcon: Icon(Icons.people),
  //                   contentPadding: EdgeInsets.only(right: 5.0, top: 8),
  //                   border: InputBorder.none),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Container(
  //           width: 200,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(25), color: Colors.blue),
  //           child: FlatButton(
  //             child: Text(
  //               "Send Recocery\nLink",
  //               textAlign: TextAlign.center,
  //               softWrap: true,
  //               style: TextStyle(
  //                 fontFamily: "Livvic",
  //                 fontSize: 22,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

//   Widget _login() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//       child: Column(
//         children: <Widget>[
//           Container(
//             width: 290,
//             child: Card(
//               elevation: 10,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25)),
//               child: TextField(
//                 style: TextStyle(fontFamily: "Livvic", fontSize: 25),
//                 controller: globals.usernameController,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(right: 5.0, top: 8),
//                   border: InputBorder.none,
//                   hintText: "E-mail",
//                   prefixIcon: Icon(Icons.people),
// //                  filled: true
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//               width: 290,
//               child: Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25)),
//                 child: TextField(
//                   obscureText: true,
//                   controller: globals.passwordController,
//                   style: TextStyle(fontFamily: "Livvic", fontSize: 25),
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "Password",
//                       prefixIcon: Icon(Icons.lock)),
//                 ),
//               )),
//           Container(
//             margin: EdgeInsets.only(left: 150),
//             child: FlatButton(
//               onPressed: () {
//                 setState(() {
//                   isProgress = true;
//                   print(isProgress);
//                 });
//                 wait();
//                 setState(() {
//                   forgotPassword = true;
//                 });
//               },
//               child: Text(
//                 "Forgot Password?",
//                 style: TextStyle(
//                     fontSize: 20, fontFamily: "Livvic", color: Colors.blue),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           loginProgress ? _inProgress() : Container(
//             width: 100,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25), color: Colors.blue),
//             child: FlatButton(
//               onPressed: () async {
//                 setState(() {
//                   loginProgress = true;
//                 });
//                 globals.isEmailLogin = true;
//                 await signInWithEmail(globals.usernameController.text,
//                     globals.passwordController.text).whenComplete(() {
//                   fdb.FirebaseDB.getUserDetails(user.uid, context);
//                 });
//               },
//               child: Text(
//                 "Login",
//                 style: TextStyle(
//                     fontFamily: "Livvic", fontSize: 22, color: Colors.white),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

  Widget _inProgress() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      ),
    );
  }

  // Widget LandscapeStack(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Stack(
  //       children: <Widget>[
  //         Positioned(
  //           child: Card(
  //             elevation: 10,
  //             child: Text("Information Dialog"),
  //           ),
  //         ),
  //         Center(
  //           child: Text("SCreen Start"),
  //         ),
  //         Positioned(
  //             bottom: 20,
  //             left: 10,
  //             right: 10,
  //             child: SizedBox(
  //               height: 60,
  //               width: 340,
  //               child: FlatButton(
  //                 textColor: Colors.white,
  //                 child: Center(
  //                   child: Text(
  //                     "Login",
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontFamily: "Livvic",
  //                         fontSize: 20),
  //                   ),
  //                 ),
  //                 splashColor: Colors.white,
  //                 onPressed: () {
  //                   signInWithGoogle().whenComplete(() {
  //                     if (user != null) {
  //                       Navigator.of(context).push(
  //                         MaterialPageRoute(
  //                           builder: (context) {
  //                             return DashBoard();
  //                           },
  //                         ),
  //                       );
  //                     } else {
  //                       Fluttertoast.showToast(
  //                           msg: "Error", toastLength: Toast.LENGTH_LONG);
  //                     }
  //                   });
  //                 },
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 color: Color(0xFF2D3E50),
  //               ),
  //             )),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> checkFillUps() async {
  //   await fdb.FirebaseDB.getUserDetails(globals.user.uid, context);
  // }
}