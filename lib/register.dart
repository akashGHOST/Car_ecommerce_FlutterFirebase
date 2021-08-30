import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_car/dialog/errorDialog.dart';
import 'package:i_car/homeScreen.dart';
import 'authenticationScreen.dart';
import 'widgers/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:i_car/GlobalVar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _phoneConfirmController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset('images/register.png', height: 270),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 400,
              child: Form(
                key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        data : Icons.person,
                        controller: _nameController,
                        hintText: "Name",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        data : Icons.mail,
                        controller: _emailController,
                        hintText: "Email",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        data : Icons.person,
                        controller: _phoneConfirmController,
                        hintText: "Phone",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        data : Icons.camera_alt_outlined,
                        controller: _imageController,
                        hintText: "Avatar URL",
                        isObsecure: false,
                      ),
                      CustomTextField(
                        data : Icons.lock,
                        controller: _passwordController,
                        hintText: "Password",
                        isObsecure: true,
                      ),
                      CustomTextField(
                        data : Icons.lock,
                        controller: _passwordConfirmController,
                        hintText: "Confirm Password",
                        isObsecure: true,
                      ),

                    ],
                  ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              // width: MediaQuery.of(context).size.width*0.5,
              child: SizedBox(
                height: 42,
                width: 120,
                child: ElevatedButton(
                  onPressed: (){
                    _register();
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void saveUserData(){
    Map<String, dynamic> userData ={
      'userName' : _nameController.text.trim(),
      'uid': userId,
      'userNumber': _phoneConfirmController.text.trim(),
      'imageProfile': _imageController.text.trim(),
      'time': DateTime.now()
    };

    FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
  }


  void _register() async {
    late User currentUser;

    await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()).then((auth){
      currentUser = auth.user!;
      userId = currentUser.uid;
      userEmail = currentUser.email!;
      getUserName = _nameController.text.trim();

      saveUserData();

      }).catchError((error){
      Route route = MaterialPageRoute(builder: (context)=> AuthenticationScreen());
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
            title: const Text('Registration Failed'),
             actions: <Widget>[
               TextButton(onPressed: () => Navigator.pushReplacement(context, route), child: Text('Retry'),)
             ],
        ));
        });

      if(currentUser != null){
          Route newRoute = MaterialPageRoute(builder: (context) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);
      }
    }
}














