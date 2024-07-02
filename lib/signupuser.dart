

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:test8/home.dart';
import 'package:test8/loginuser.dart';
import 'package:test8/main.dart';






class signupuser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpPage(),
        '/homepage': (context) => home(),
        // other routes...
      },
    );
  }
}

class SignUpPage extends StatelessWidget {
  final FirebaseAuthService _auth =FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void dispose(){
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ProFinder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign Up as a User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
           
            SizedBox(height: 20),
            ElevatedButton(
             onPressed: () => _signUp(context),
            
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'If you already have an account,',
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                
              
               Navigator.push(context, MaterialPageRoute(builder: (context)=>loginuser()));
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp(BuildContext context) async{
    String Username=_usernameController.text;
    String email=_emailController.text;
    String password=_passwordController.text;

    User? user=await _auth.signupWithEmailAndpassword(email, password);

    if(user!=null){
      print("user is succesfully created");
      Navigator.pushNamed(context, "/homepage");
    }
    else{
      print("some error occured");
    }

  }

}
