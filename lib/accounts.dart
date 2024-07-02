import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/home.dart';
import 'package:test8/notification.dart';
import 'package:test8/category.dart';
import 'package:test8/requests.dart';


class accounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserRegistrationPage(),
    );
  }
}

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  User? currentUser;
  late DocumentReference userDocRef;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
      _loadUserData();
    }
  }

  void _loadUserData() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = userData['name'] ?? '';
          locationController.text = userData['location'] ?? '';
          mobileController.text = userData['mobile'] ?? '';
        });
      }
    }
  }

  void registerUser(BuildContext context) {
    String name = nameController.text;
    String location = locationController.text;
    String mobile = mobileController.text;

    // Save user data to Firestore
    if (currentUser != null) {
      userDocRef.set({
        'name': name,
        'location': location,
        'mobile': mobile,
      });
    }

    // Navigate to next page (e.g., home page)
    Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: locationController, decoration: InputDecoration(labelText: 'Location')),
            TextField(controller: mobileController, decoration: InputDecoration(labelText: 'Mobile Number')),
            ElevatedButton(
              onPressed: () => registerUser(context),
              child: Text('Save Data'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.request_page, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => requests()));
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => notification()));
              },
            ),
            IconButton(
              icon: Icon(Icons.category, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => category()));
              },
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => accounts()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
