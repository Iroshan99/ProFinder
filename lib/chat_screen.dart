import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  late DialogFlowtter dialogFlowtter;

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile(path: "assets/dialog_flow_auth.json").then((instance) {
      setState(() {
        dialogFlowtter = instance;
      });
    });
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      messages.insert(0, {
        "message": {"text": text},
        "isUserMessage": true,
      });
    });

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message != null) {
      setState(() {
        messages.insert(0, {
          "message": {"text": response.message!.text!.text![0]},
          "isUserMessage": false,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: messages[index]['isUserMessage']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: messages[index]['isUserMessage']
                          ? Colors.blue
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Text(messages[index]['message']['text']),
                  ),
                );
              },
            ),
          ),
          Divider(height: 5.0),
          ListTile(
            title: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter a message...",
                border: OutlineInputBorder(),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                sendMessage(_controller.text);
                _controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
