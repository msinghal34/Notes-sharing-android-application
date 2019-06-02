import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Required for debugPaintSizeEnabled
import 'dart:convert';
import 'session.dart';
import 'filesDisplay.dart';

class Explore extends StatefulWidget {
  @override
  Explore({this.jsonString});
  final jsonString;
  List<String> disciplines = [];
  Map<String, List<String>> subjects = new Map();
  ExploreState createState() => ExploreState(jsonString: this.jsonString, disciplines: this.disciplines, subjects: this.subjects);
}

class ExploreState extends State<Explore> {
  ExploreState({this.jsonString, this.disciplines, this.subjects});
  String jsonString;
  List<String> disciplines;
  Map<String, List<String>> subjects;

  void loadSubjects() async {
    var session = new Session();
    if(jsonString == null) {
      print('Explore servlet called');
      jsonString = await session.get(session.url + "ExploreServlet");
    }

      var parsed = json.decode(jsonString);
      print(parsed);
      setState(() {
        for (var item in parsed["data"]) {
          List<String> list = item["subject"].split(",");
          subjects.putIfAbsent(item["discipline"].toString(), () => list);
        }
        disciplines.addAll(subjects.keys);
      });

    }


  void files(String discipline, String subject) async {
    var session = new Session();
    String request = session.url +
        "SearchServlet?subject=" +
        subject +
        "&discipline=" +
        discipline;
    print(request);
    var response = await session.get(request);
    var parsed = json.decode(response);
    print(parsed);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FilesDisplay(
                  fList: parsed,
                  sortParam: "likes",
                  name: subject,
              selectedIndex: 0,
                )));
  }

  @override
  Widget build(BuildContext context) {

    Widget list(int index) {
      return new SizedBox(
          height: 200.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(disciplines[index],
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Theme.of(context).accentColor)),
              ),
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  itemExtent: 140.0,
                  itemCount: subjects[disciplines[index]].length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int secondIndex) {
                    return GestureDetector(
                      onTap: () {
                        files(disciplines[index],
                            subjects[disciplines[index]][secondIndex]);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'images/' + disciplines[index] + '.png',
                              height: 50.0,
                            ),
                            Text(
                              subjects[disciplines[index]][secondIndex],
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor
                                ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Divider(),
            ],
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: Container(
//        decoration: new BoxDecoration(
//          image: new DecorationImage(
//            image: new AssetImage("images/background.png"),
//            fit: BoxFit.cover,
//          ),
//        ),
        child: ListView.builder(
          itemExtent: 150.0,
          itemCount: disciplines.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return list(index);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }
}
