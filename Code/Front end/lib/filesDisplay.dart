import 'package:flutter/material.dart';
import 'fileDetail.dart';
import 'home.dart';

class FilesDisplay extends StatefulWidget {
  FilesDisplay({this.fList, this.name, this.sortParam, this.selectedIndex});
  final fList;
  final String name;
  final String sortParam;
  int selectedIndex;
  @override //new
  State createState() => new FilesDisplayState(
      name: this.name,
      fList: this.fList,
      sortParam: this.sortParam,
      selectedIndex: this.selectedIndex);
}

class SortParam {
  const SortParam({this.title});
  final String title;
}

const List<SortParam> sortParams = const <SortParam>[
  const SortParam(title: "likes"),
  const SortParam(title: "views"),
  const SortParam(title: "year"),
];

class FilesDisplayState extends State<FilesDisplay> {
  FilesDisplayState(
      {this.name, this.fList, this.sortParam, this.selectedIndex});
  String sortParam;
  final String name;
  final fList;
  String dropString;
  int selectedIndex;

  final List<File> _fList = <File>[]; // new

  void _loadFilesHelper(SortParam s) {
    sortParam = s.title;
    loadFiles();
  }

  void loadFiles() async {
    _fList.clear();
    setState(() {
      var parsed = fList; //new
      for (var v in parsed['data']) {
        _fList.add(new File(
          fid: v['fid'],
          filename: v['filename'],
          year: v['year'],
          uploadedBy: v['uploaded_by'],
          likes: v['likes'],
          views: v['views'],
          institute: v['institute'],
          discipline: v['discipline'],
          subject: v['subject'],
          liked: v['liked'],
          favo: v['favo'],
          selectedIndex: selectedIndex,
        ));
      }
      print('In loadFiles ' + sortParam);
      if (sortParam != 'likes' &&
          sortParam != 'views' &&
          sortParam != 'year' &&
          sortParam != 'dontSort') {
        sortParam = 'likes';
      }
      if (sortParam == 'likes') {
        _fList.sort((a, b) => int.parse(b.likes).compareTo(int.parse(a.likes)));
      }
      if (sortParam == 'views') {
        _fList.sort((a, b) => int.parse(b.views).compareTo(int.parse(a.views)));
      }
      if (sortParam == 'year') {
        print('Inside year');
        _fList.sort((a, b) => int.parse(b.year).compareTo(int.parse(a.year)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  @override //new
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.name),
        actions: <Widget>[
          PopupMenuButton<SortParam>(
              tooltip: "Sort",
//              onSelected: _loadFilesHelper,
              icon: Icon(Icons.sort),
              itemBuilder: (BuildContext context) {
                return sortParams.map((SortParam s) {
                  return new PopupMenuItem<SortParam>(
                      child: ListTile(
                    title: Text(s.title),
                    onTap: () {
                      _loadFilesHelper(s);
                    },
                  ));
                }).toList();
              }),
        ],
      ),

      body: new Column(
        //modified
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
                padding: new EdgeInsets.all(8.0), //new
                reverse: false, //new
                itemCount: _fList.length, //new
                itemBuilder: (_, int index) => _fList[index] //new
                ), //new
          ), //new//new
        ], //new
      ), //new
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), title: Text('Explore')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload), title: Text('Upload')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
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
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(selectedIndex: index)));
    });
  }
}

class File extends StatelessWidget {
  File(
      {this.institute,
      this.filename,
      this.fid,
      this.year,
      this.likes,
      this.views,
      this.uploadedBy,
      this.subject,
      this.discipline,
      this.liked,
      this.favo,
      this.selectedIndex});
  final String institute,
      filename,
      fid,
      year,
      uploadedBy,
      likes,
      views,
      discipline,
      subject,
      liked,
      favo;
  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FileDetail(
                      fid: fid,
                      filename: filename,
                      year: year,
                      uploadedBy: uploadedBy,
                      likes: likes,
                      views: views,
                      institute: institute,
                      discipline: discipline,
                      subject: subject,
                      liked: liked,
                      favo: favo,
                      selectedIndex: selectedIndex,
                    )),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(filename, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.thumb_up,
                            size: 16.0, color: Theme.of(context).accentColor),
                        Text("  " + likes.toString()),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.remove_red_eye,
                            size: 16.0, color: Theme.of(context).accentColor),
                        Text("  " + views.toString()),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.date_range,
                            size: 16.0, color: Theme.of(context).accentColor),
                        Text("  " + year.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 12.0,
                color: Colors.black,
              ),
            ],
          ),
        ));
  }
}
