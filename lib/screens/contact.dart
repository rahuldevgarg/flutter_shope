import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red[800],
        title: Text("Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.topLeft,
              child: Text(
                "Questions about an issue?",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Text("Feel free to Ask!"),
            SizedBox(height: 50.0),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Call us at :"),
                  Text("+91-7406841682",
                      style: TextStyle(color: Colors.blueGrey))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchTwitter() async {
    const url = 'https://twitter.com/_iamramu';
    if (await canLaunch(Uri.encodeFull(url))) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchgithub() async {
    const url = 'https://github.com/bugudiramu';
    if (await canLaunch(Uri.encodeFull(url))) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchlinkedIn() async {
    const url = 'https://www.linkedin.com/in/bugudi-ramu-2a5a5a161/';
    if (await canLaunch(Uri.encodeFull(url))) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
