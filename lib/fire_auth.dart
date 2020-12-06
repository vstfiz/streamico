import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
FirebaseAuth auth = FirebaseAuth.instance;
User user;
String yourClientId = "226970795296107";
String yourRedirectUrl =
    "https://www.facebook.com/connect/login_success.html";

Future<User> signInWithGoogle() async {
  bool isSignedIn = await _googleSignIn.isSignedIn();
  if (isSignedIn) {
    user = await auth.currentUser;
  } else {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    // ignore: deprecated_member_use
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    user = (await auth.signInWithCredential(credential)).user;
  }
  return user;
}

Future<User> signUpWithEmail(String email, String password) async {
  UserCredential sUser = await auth.createUserWithEmailAndPassword(
      email: email, password: password);
  user = sUser.user;
  return sUser.user;
}

Future<User> signInWithEmail(String email, String password) async {
  UserCredential result = await auth.signInWithEmailAndPassword(
      email: email, password: password);
  user = result.user;
  return result.user;
}

Future<User> signOutWithGoogle() async {
  await _googleSignIn.signOut();
  await auth.signOut();
  return null;
}


class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.selectedUrl,
    );
  }
}