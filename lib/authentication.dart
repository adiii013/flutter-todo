import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

bool login = true;
String forlogin = "Already have an account?";
String forsignin = "Does not have account?";

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void sign() {
      
        FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString());
      
      emailController.clear();
      passwordController.clear();
    }

    void log() {
      try {
        FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString());
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
            msg: 'Wrong Email or Password',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Todo App',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: (login) ? Text("Login") : Text("Sign in"),
                        onPressed: () {
                          (login) ? log() : sign();
                        },
                      )),
                  Row(
                    children: <Widget>[
                      (login) ? Text(forsignin) : Text(forlogin),
                      TextButton(
                        child: (login)
                            ? Text(
                                "Sign in",
                                style: TextStyle(fontSize: 20),
                              )
                            : Text(
                                "Login",
                                style: TextStyle(fontSize: 20),
                              ),
                        onPressed: () {
                          setState(() {
                            (login) ? (login = false) : (login = true);
                          });
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ))),
    );
  }
}
