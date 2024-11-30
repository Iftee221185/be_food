import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


class Delevaryfeed extends StatefulWidget {
  const Delevaryfeed({super.key});

  @override
  State<Delevaryfeed> createState() => _DelevaryfeedState();
}

class _DelevaryfeedState extends State<Delevaryfeed> {

  // Function to make a phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text('Could not launch phone call to $phoneNumber'),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }

  // Function to send an SMS
  Future<void> sendSMS(String phoneNumber) async {
    Uri uri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text('Could not send SMS to $phoneNumber'),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Widget> clientWidgets = [];
          final clients = snapshot.data?.docs.reversed.toList() ?? [];

          for (var client in clients) {
            if (client['role'] == 'Delevary-Man') {
              final phoneNumber = client['number'];  // Assuming `phone` field exists
              final clientWidget = Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(client['imageurl'] ?? ''),
                  ),
                  title: Text(
                    client['name'],
                    style: GoogleFonts.abel(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    client['location'] ?? '',
                    style: GoogleFonts.abel(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () => makePhoneCall(phoneNumber),
                      ),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () => sendSMS(phoneNumber),
                      ),
                    ],
                  ),
                ),
              );
              clientWidgets.add(clientWidget);
            }
          }

          return ListView(
            children: clientWidgets,
          );
        },
      ),
    );
  }
}
