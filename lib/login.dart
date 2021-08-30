import 'package:flutter/material.dart';
import 'package:i_car/dialog/loadingDialog.dart';
import 'package:i_car/homeScreen.dart';
import 'package:i_car/widgers/customTextField.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authenticationScreen.dart';

class Login extends StatefulWidget {
  // const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;
    
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'images/login.png',
                  height: 270,
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                        data : Icons.person,
                        controller: _emailController,
                        hintText: "Email",
                        isObsecure: false,
                    ),
                    CustomTextField(
                      data : Icons.lock,
                      controller: _passwordController,
                      hintText: "Password",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              // width: MediaQuery.of(context).size.width * 0.5,
              child: SizedBox(
                height: 42,
                width: 120,
                child: ElevatedButton(
                  onPressed: (){
                    _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty? _login() : showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                      title: const Text('Log In Failed'),
                      actions: <Widget>[
                        TextButton(onPressed: ()=> Navigator.pop(context, 'Retry'), child: const Text('Retry'))
                      ],
                    ));
                  },
                  child: Text(
                      'Log In',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
  
  void _login() async {
    // showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
    //   title: const Text('Please Wait...'),
    //   actions: <Widget>[
    //     TextButton(onPressed: ()=> Navigator.pop(context, 'Proceed'), child: const Text('Proceed'))
    //   ],
    // ));

    late User currentUser;

    await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
    ).then((auth){
      currentUser = auth.user!;
    }).catchError((error){
      Route route = MaterialPageRoute(builder: (context)=> AuthenticationScreen());
      showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
        title: const Text('Log In Failed'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pushReplacement(context, route), child: Text('Retry'),)
        ],
      ));
    });

    if(currentUser != null){
      Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, newRoute);
    } else {
      print('error logging in');
    }
  }
}

