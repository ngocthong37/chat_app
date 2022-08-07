import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/screens/auth/login_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/shared/constant.dart';
import 'package:chat_app/widgets/button_widget.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String name = "";
  bool isLoading = false;

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
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
                            height: 250,
                            width: double.infinity,
                            child: Image.asset(
                              "assets/register.png",
                              fit: BoxFit.cover,
                            )),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Constants.primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            // Return null if the entered email is valid
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              register();
                            },
                            child: const ButtonWidget(text: "Register")),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(
                          TextSpan(
                              text: "Have already an account?",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                              children: [
                                const TextSpan(
                                  text: "  ",
                                ),
                                TextSpan(
                                    text: "Login now",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextSceenReplace(context, LoginPage());
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

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(name.toString().trim(),
              email.toString(), password.toString().trim())
          .then((value) async {
        if (value == true) {
          // saving prereference
          await HelperFuctions.saveUserLoggedInStatus(true);
          await HelperFuctions.saveEmailNameSF(email);
          await HelperFuctions.saveUserNameSF(name);

          nextSceenReplace(context, HomePage());
          showSnackBar(context, Colors.green, "Register successfully");
        } else {
          // notify error
          showSnackBar(context, Colors.red, value);
        }
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
