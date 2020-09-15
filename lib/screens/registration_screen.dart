import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  bool spinner = false;
  String email;
  String password1;
  String password2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter email id.'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password1 = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password.')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password2 = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Confirm password.')
              ),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'button2',
                child: RoundedButton(
                  buttonColor: Colors.blueAccent,
                  text: 'Register',
                  onPressed: () async{
                    if(password1 == password2) {
                      setState(() {
                        spinner = true;
                      });
                      try {
                        final newUser = await _auth
                            .createUserWithEmailAndPassword(
                            email: email, password: password1);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          spinner = false;
                        });
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: 'Oops! Something went Wrong.',
                          toastLength: Toast.LENGTH_SHORT,);
                        print(e);
                      }
                    }else{
                      Fluttertoast.showToast(
                        msg: "Password didn't match!",
                        toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.grey,
                        textColor: Colors.white,);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
