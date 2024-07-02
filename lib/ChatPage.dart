import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String selectedRecipientId = '';
  List<String> userNames = [];
  Map<String, String> nameToIdMap = {};

  @override
  void initState() {
    super.initState();
    _loadUserNames();
  }

  void _loadUserNames() async {
    // Load names from users collection
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in userSnapshots.docs) {
      nameToIdMap[doc['name']] = doc.id;
      userNames.add(doc['name']);
    }
    // Load names from service_providers collection
    QuerySnapshot serviceProviderSnapshots = await FirebaseFirestore.instance.collection('service_providers').get();
    for (var doc in serviceProviderSnapshots.docs) {
      nameToIdMap[doc['name']] = doc.id;
      userNames.add(doc['name']);
    }
    setState(() {});
  }

  void sendMessage() {
    String message = messageController.text.trim();
    if (message.isNotEmpty && selectedRecipientId.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'senderId': currentUser?.uid,
        'receiverId': selectedRecipientId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: Text('Select Recipient'),
            value: selectedRecipientId.isEmpty ? null : selectedRecipientId,
            onChanged: (String? newValue) {
              setState(() {
                selectedRecipientId = newValue!;
              });
            },
            items: userNames.map((String name) {
              return DropdownMenuItem<String>(
                value: nameToIdMap[name],
                child: Text(name),
              );
            }).toList(),
          ),
          Expanded(
            child: selectedRecipientId.isEmpty
                ? Center(child: Text('Select a recipient to start chatting'))
                : MessagesList(currentUser!.uid, selectedRecipientId),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesList extends StatelessWidget {
  final String currentUserId;
  final String recipientId;

  MessagesList(this.currentUserId, this.recipientId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('senderId', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var sentMessages = snapshot.data!.docs;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .where('receiverId', isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var receivedMessages = snapshot.data!.docs;

            var messages = [...sentMessages, ...receivedMessages]
                .where((message) =>
                    (message['senderId'] == currentUserId && message['receiverId'] == recipientId) ||
                    (message['senderId'] == recipientId && message['receiverId'] == currentUserId))
                .toList()
                  ..sort((a, b) => (a['timestamp'] as Timestamp).compareTo(b['timestamp'] as Timestamp));

            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isSentByCurrentUser = message['senderId'] == currentUserId;
                return ListTile(
                  title: Align(
                    alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: isSentByCurrentUser ? Colors.blue[100] : Colors.grey[300],
                      child: Text(message['message']),
                    ),
                  ),
                  subtitle: Align(
                    alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(isSentByCurrentUser ? 'You' : recipientId),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
