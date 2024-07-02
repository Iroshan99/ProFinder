import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/RequestHistoryPage.dart';
import 'package:test8/homeprovider.dart';
import 'package:test8/requests.dart';


class accountprovider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServiceProviderRegistrationPage(),
    );
  }
}

// Service provider registration page
class ServiceProviderRegistrationPage extends StatefulWidget {
  @override
  _ServiceProviderRegistrationPageState createState() => _ServiceProviderRegistrationPageState();
}

class _ServiceProviderRegistrationPageState extends State<ServiceProviderRegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  User? currentUser;
  late DocumentReference userDocRef;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userDocRef = FirebaseFirestore.instance.collection('service_providers').doc(currentUser!.uid);
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
          categoryController.text = userData['category'] ?? '';
          priceController.text = userData['price']?.toString() ?? '';
        });
      }
    }
  }

  void registerServiceProvider(BuildContext context) {
    String name = nameController.text;
    String location = locationController.text;
    String mobile = mobileController.text;
    String category = categoryController.text;
    double price = double.parse(priceController.text);

    // Save service provider data to Firestore
    if (currentUser != null) {
      userDocRef.set({
        'name': name,
        'location': location,
        'mobile': mobile,
        'category': category,
        'price': price,
      });
    }

    // Navigate to next page (e.g., home page)
    Navigator.push(context, MaterialPageRoute(builder: (context) => homeprovider()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => homeprovider()));
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
            TextField(controller: categoryController, decoration: InputDecoration(labelText: 'Category')),
            TextField(controller: priceController, decoration: InputDecoration(labelText: 'Price')),
            ElevatedButton(
              onPressed: () => registerServiceProvider(context),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => RequestHistoryPage()));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => accountprovider()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
