import 'package:flutter/material.dart';
import 'session.dart';
import 'package:flutter/rendering.dart'; // Required for debugPaintSizeEnabled
import 'dart:convert';
import 'main.dart';
import 'home.dart';
import 'filesDisplay.dart';

class MyProfile extends StatefulWidget {
  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  String name = "Your Name";
  String emailID = "email ID";
  String reputation = "0";

  void loadName() async {
    var session = new Session();
    var response = await session.get(session.url + "Profile");
    var parsed = json.decode(response);
    print(parsed);
    setState(() {
      if (parsed["status"] == true) {
        for (var item in parsed["data"]) {
          name = item["name"];
          emailID = item["email_id"];
          reputation = item["reputation"];
        }
      } else {
        //TODO
      }
    });
  }

  void logout() async {
    var session = new Session();
    var response = await session.get(session.url + "LogoutServlet");
    var parsed = json.decode(response);
    print(parsed);
    if (parsed["status"] == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      //TODO
    }
  }

  void history() async {
    var session = new Session();
    var response = await session.get(session.url + "ReturnHistory");
    var parsed = json.decode(response);
    print(parsed);
    if (parsed["status"] == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FilesDisplay(
                    fList: parsed,
                    sortParam: "dontSort",
                    name: "History",
                selectedIndex: 3,
                  )));
    } else {
      //TODO
    }
  }

  void favorites() async {
    var session = new Session();
    var response = await session.get(session.url + "ReturnFavourites");
    var parsed = json.decode(response);
    print(parsed);
    if (parsed["status"] == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FilesDisplay(
                    fList: parsed,
                    sortParam: "likes",
                    name: "Favorites",
                selectedIndex: 3,
                  )));
    } else {
      //TODO
    }
  }

  void uploads() async {
    var session = new Session();
    var response = await session.get(session.url + "ReturnUploads");
    var parsed = json.decode(response);
    print(parsed);
    if (parsed["status"] == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FilesDisplay(
                    fList: parsed,
                    sortParam: "year",
                    name: "Uploads",
                selectedIndex: 3,
                  )));
    } else {
      //TODO
    }
  }

  @override
  void initState() {
    super.initState();
    loadName();
  }

  @override
  Widget build(BuildContext context) {
    // Top Header
    Widget topHeader = Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.person,
            size: 48.0,
            color: Theme.of(context).accentColor,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22.0),
                    ),
                    Text(
                      emailID,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ]),
            ),
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          Text(reputation)
        ],
      ),
    );

    // List of options
    Widget list = Flexible(
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: <Widget>[
          ListTile(
              leading:
                  Icon(Icons.history, color: Theme.of(context).accentColor),
              title: Text('History'),
              onTap: () {
                history();
              }),
          ListTile(
              leading:
                  Icon(Icons.favorite, color: Theme.of(context).accentColor),
              title: Text('Favorites'),
              onTap: () {
                favorites();
              }),
          ListTile(
              leading:
                  Icon(Icons.file_upload, color: Theme.of(context).accentColor),
              title: Text('Uploads'),
              onTap: () {
                uploads();
              }),
          ListTile(
              leading:
                  Icon(Icons.exit_to_app, color: Theme.of(context).accentColor),
              title: Text('Logout'),
              onTap: () {
                logout();
              }),
        ],
      ),
    );

    // Final Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Column(
        children: <Widget>[topHeader, Divider(), list],
      ),
    );
  }
}
