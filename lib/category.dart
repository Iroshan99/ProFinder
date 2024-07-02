import 'package:flutter/material.dart';
import 'package:test8/ChatPage.dart';
import 'package:test8/accounts.dart';
import 'package:test8/home.dart';
import 'package:test8/notification.dart';
import 'package:test8/painter.dart';
import 'package:test8/caregiver.dart';
import 'package:test8/chef.dart';
import 'package:test8/electricion.dart';
import 'package:test8/plumber.dart';
import 'package:test8/requests.dart';
import 'package:test8/tutor.dart';




class category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProFinderPage(),
    );
  }
}

class ProFinderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'category',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>home()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                CategoryButton(
                  title: 'Plumber',
                  icon: Icons.build,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>plumber()));
                   
                    // Navigate to plumber service providers page
                    // You can use Navigator.push() here
                  },
                ),
                CategoryButton(
                  title: 'Painter',
                  icon: Icons.format_paint,
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>painter()));
                    // Navigate to painter service providers page
                  },
                ),
                CategoryButton(
                  title: 'Electrician',
                  icon: Icons.flash_on,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>electricion()));
                    // Navigate to electrician service providers page
                  },
                ),
                CategoryButton(
                  title: 'Chef',
                  icon: Icons.restaurant,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>chef()));
                    // Navigate to chef service providers page
                  },
                ),
                CategoryButton(
                  title: 'Coaching',
                  icon: Icons.school,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>tutor()));
                    // Navigate to coaching service providers page
                  },
                ),
                CategoryButton(
                  title: 'Care Giver',
                  icon: Icons.favorite,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>caregiver()));
                    // Navigate to care giver service providers page
                  },
                ),
              ],
            ),
          ),
        ],
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

class CategoryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  CategoryButton({required this.title, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
