// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../storage/local_storage.dart';
import 'package:front/widgets/assets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/api_service/authenication.dart';

class LoginPage extends StatefulWidget {
  final Data localData;

  const LoginPage({Key? key, required this.localData}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Stack(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: const Color.fromRGBO(17, 32, 51, 1),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                )
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 60),
                width: 150,
                height: 150,
                child: Image.asset(
                  'assets/icon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 30,),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(17, 32, 51, 1),
                ),
              ),
            ),
          ),
          _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: TextFormField(
                          cursorColor: Colors.grey,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _loginUser();
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 40, right: 40, top: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff1B2A4E),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Authentication.signInWithGoogle(context: context);
                          FirebaseAuth.instance.authStateChanges().listen((user) {
                            if (user != null) {
                              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                            } 
                          }
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        margin: const EdgeInsets.only(left: 40, right: 40, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          color: Colors.white, // change the background color to white
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/google_login_icon/g-logo.png',
                                width: 36,
                              ),
                              const SizedBox(width: 24,),
                              const Text(
                                'SIGN IN WITH GOOGLE',
                                style: TextStyle(
                                  color: Color.fromARGB(138, 0, 0, 0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;

    var response = await http.post(
      Uri.parse('https://example.com/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> userData = jsonDecode(response.body);
      widget.localData.saveUserData(userData);
      // Navigate to the main page
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
