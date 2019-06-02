import 'package:flutter/material.dart';
import 'profile.dart';
import 'explore.dart';
import 'uploadFile.dart';
import 'searchFile.dart';
import 'session.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({this.selectedIndex});
  final int selectedIndex;
  @override
  _MyHomePageState createState() => _MyHomePageState(selectedIndex: selectedIndex);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.selectedIndex});
  int selectedIndex = 0;
  static var json;
  final _widgetOptions = [
    Explore(jsonString: json),
    SearchFile(),
    UploadFile(),
    MyProfile(),
  ];
  void getExplore() async {
    print('Inside json');
    var session = new Session();
    var response = await session.get(session.url + "ExploreServlet");
    setState(() {
      print(response);
      json = response;
    });
  }

  @override
  void initState(){
    super.initState();
    if(json == null){
      getExplore();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Material(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.explore), title: Text('Explore')),
          BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(icon: Icon(Icons.file_upload), title: Text('Upload')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile')),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        fixedColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(selectedIndex: index)));
    });
  }
}