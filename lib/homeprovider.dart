import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/chat_screen.dart';
import 'package:test8/homeprovider.dart';
import 'package:test8/accountprovider.dart';
import 'package:test8/notification.dart';
import 'package:test8/RequestHistoryPage.dart'; // Import the new RequestHistoryPage

class homeprovider extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<homeprovider> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<String> fetchUserName(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('service_providers').doc(userId).get();
    if (userDoc.exists) {
      return userDoc['name'] ?? 'Unknown User';
    }
    return 'Unknown User';
  }

  void sendMessage(String userId, String userName, String message) {
    FirebaseFirestore.instance.collection('messages').add({
      'userId': userId,
      'userName': userName, // Store the user's name
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void updateRequestStatus(String requestId, String status, String userId, BuildContext context) async {
    String userName = await fetchUserName(currentUser?.uid ?? '');

    FirebaseFirestore.instance.collection('requests').doc(requestId).update({
      'status': status,
    });

    FirebaseFirestore.instance.collection('status_updates').add({
      'requestId': requestId,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
      'serviceProviderId': currentUser?.uid,
      'userId': userId,
      'userName': userName,
    });

    String message = status == 'accepted' ? 'Your request from $userName has been accepted' : 'Your request from $userName has been rejected';
    sendMessage(userId, userName, message);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Request $status'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Requests'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('serviceProviderId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestId = request.id;
              final userId = request['userId'];
              final userName = request['userName'];
              final Map<String, dynamic>? requestData = request.data() as Map<String, dynamic>?;
              final userLocation = requestData?['userLocation'] ?? 'Location Not Available';
              return ListTile(
                title: Text(userName),
                subtitle: Text(userLocation),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => updateRequestStatus(requestId, 'accepted', userId, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Accept'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => updateRequestStatus(requestId, 'rejected', userId, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Reject'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.history, color: Colors.white),
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
