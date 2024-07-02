import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/accountprovider.dart';

class RequestHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Request History'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('status_updates')
            .where('serviceProviderId', isEqualTo: currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Logging for debugging
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Connection state: waiting");
          }
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            print("No data available");
            return Center(child: CircularProgressIndicator());
          }

          final updates = snapshot.data!.docs;
          print("Number of updates: ${updates.length}");

          if (updates.isEmpty) {
            return Center(child: Text('No request history found.'));
          }

          return ListView.builder(
            itemCount: updates.length,
            itemBuilder: (context, index) {
              final update = updates[index];
              final requestId = update['requestId'];
              final status = update['status'];
              final userName = update['userName'];
              final timestamp = update['timestamp']?.toDate();

              return ListTile(
                title: Text('Request ID: $requestId'),
                subtitle: Text(
                    'User: $userName\nStatus: $status\nTime: ${timestamp != null ? timestamp.toString() : 'Unknown time'}'),
              );
            },
          );
        },
      ),
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
