import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/accounts.dart';
import 'package:test8/category.dart';
import 'package:test8/notification.dart';
import 'package:test8/requests.dart';

class electricion extends StatefulWidget {
  @override
  _PaintersPageState createState() => _PaintersPageState();
}

class _PaintersPageState extends State<electricion> {
  User? currentUser;
  late DocumentReference userDocRef;
  String userName = '';
  String userLocation = '';

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
      _loadUserProfile();
    }
  }

  void _loadUserProfile() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userName = userData['name'] ?? '';
          userLocation = userData['location'] ?? '';
        });
      }
    }
  }

  void _sendServiceRequest(String serviceProviderId, String serviceProviderName, double price) async {
    if (currentUser != null) {
      FirebaseFirestore.instance.collection('requests').add({
        'serviceProviderId': serviceProviderId,
        'serviceProviderName': serviceProviderName,
        'userId': currentUser!.uid,
        'userName': userName,
        'userLocation': userLocation,
        'price': price,
        'status': 'pending',
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service request sent')));
    }
  }

  Color _getColorFromName(String name) {
    final int hash = name.hashCode;
    final int colorValue = 0xFF000000 + (hash & 0x00FFFFFF);
    return Color(colorValue).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Electricions'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('service_providers')
              .where('category', isEqualTo: 'electricion')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final painters = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: painters.length,
              itemBuilder: (context, index) {
                final painter = painters[index];
                final painterName = painter['name'];
                return ListTile(
                  leading: Icon(
                    Icons.brush,
                    color: _getColorFromName(painterName),
                  ),
                  title: Text(painterName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(painter['location']),
                      SizedBox(height: 4),
                      Text('₹${painter['price']}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceProviderProfile(
                          serviceProviderId: painter.id,
                        ),
                      ),
                    );
                  },
                  trailing: ElevatedButton(
                    onPressed: () => _sendServiceRequest(painter.id, painterName, painter['price']),
                    child: Text('Service Request'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                );
              },
            );
          },
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
                // Handle requests
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => notification()));
                // Handle notifications
              },
            ),
            IconButton(
              icon: Icon(Icons.category, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => category()));
                // Handle category
              },
            ),
            IconButton(
              icon: Icon(Icons.chat, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
                // Handle chat
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => accounts()));
                // Handle account
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceProviderProfile extends StatelessWidget {
  final String serviceProviderId;

  ServiceProviderProfile({required this.serviceProviderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Profile'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('service_providers').doc(serviceProviderId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var serviceProviderData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${serviceProviderData['name']}', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('Location: ${serviceProviderData['location']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Price: ₹${serviceProviderData['price']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Category: ${serviceProviderData['category']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Mobile: ${serviceProviderData['mobile']}', style: TextStyle(fontSize: 18)),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Handle payment logic here
                  },
                  child: Text('Pay Now'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}