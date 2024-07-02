import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test8/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:test8/home.dart';
import 'package:test8/signupuser.dart';


class loginuser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/homepage': (context) => home(),
        // other routes...
      },
   
    );
  }
}

class SignInPage extends StatelessWidget {
  final FirebaseAuthService _auth =FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void dispose(){
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>signupuser()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Log In as User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email or Phone No',
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
                onPressed: () => _signIn(context),
                // Validate the text input fields here
                // If both fields are properly filled, proceed with login
            
              style: ElevatedButton.styleFrom(
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

  void _signIn(BuildContext context) async{
    String email=_emailController.text;
    String password=_passwordController.text;

    User? user=await _auth.signInWithEmailAndpassword(email, password);

    if(user!=null){
      print("succesfully log in");
      Navigator.pushNamed(context, "/homepage");
    }
    else{
      print("some error occured");
    }

  }
}
