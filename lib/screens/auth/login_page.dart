import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constant.dart';
import 'package:chat_app/widgets/button_widget.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
  : SingleChildScrollView(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Groupie",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Login now to see what they are talking!",
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/login.png",
                    fit: BoxFit.cover,
                  )),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Constants.primaryColor,
                    )),
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email address';
                  }
                  // Check if the entered email has the right format
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  // Return null if the entered email is valid
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                obscureText: true,
                decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Constants.primaryColor,
                    )),
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters in length';
                  }
                  // Return null if the entered password is valid
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                  onTap: () {
                    login();
                  },
                  child: const ButtonWidget(text: "Login")),
              const SizedBox(
                height: 15,
              ),
              Text.rich(
                TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(
                        color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(
                        text: "  ",
                      ),
                      TextSpan(
                        text: "Register here",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            nextSceenReplace(context, RegisterPage());
                          },
                        style: const TextStyle(
                            decoration: TextDecoration.underline))
                    ]),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithEmailAndPassword(email.toString().trim(), password.toString().trim()).then(
        (value) async {
          if (value == true) {
            QuerySnapshot snapshot = await DatabaseService(
              uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email.toString().trim());
                await HelperFuctions.saveUserLoggedInStatus(true);
                await HelperFuctions.saveEmailNameSF(email);
                await HelperFuctions.saveUserNameSF(
                  snapshot.docs[0]['fullName']
                );
            nextSceenReplace(context, HomePage());
            showSnackBar(context, Colors.green, "Login successful");
          } else {
            setState(() {
              _isLoading = false;
            });
            showSnackBar(context, Colors.red, value);
          }
          setState(() {
            _isLoading = false;
          });
        },
      );
      
    }
  }
}
