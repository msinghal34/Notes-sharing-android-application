import 'package:flutter/material.dart';
import 'home.dart';
import 'session.dart';
import 'dart:convert';
import 'package:flutter_pdf_viewer/flutter_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class FileDetail extends StatefulWidget {
  FileDetail(
      {this.institute,
      this.filename,
      this.fid,
      this.year,
      this.likes,
      this.views,
      this.uploadedBy,
      this.subject,
      this.discipline,
      this.favo,
      this.liked,
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
  FileDetailState createState() => FileDetailState(
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
      );
}

class FileDetailState extends State<FileDetail> {
  FileDetailState(
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
  String institute,
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

  Future<String> localTempPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<String> localPermPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path + '/Download';
  }

  Future<String> localFilePath(String place, String fName) async {
    var path;
    if (place == 'view') {
      path = await localTempPath();
    } else {
      path = await localPermPath();
    }
    return '$path/' + fName + '.pdf';
  }

  Future<String> getFile(String fid, String fName, String place) async {
    var sess = new Session();
    Dio dio = new Dio();

    String filePath = await localFilePath(place, fName);
    try {
      await dio.download(sess.url + 'DownloadServlet?fid=' + fid, filePath,
          // Listen the download progress.
          onProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      }, options: new Options(headers: sess.headers));
    } on DioError catch (e) {
      return "Failed";
    }
    return filePath;
  }

  void foo() {
    if (liked == null) {
      isLiked = false;
    } else {
      isLiked = true;
    }
    if (favo == null) {
      isFavorite = false;
    } else {
      isFavorite = true;
    }
  }

  bool isLiked = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    foo();
  }

  TextStyle textStyle =
      TextStyle(fontSize: 16.0, fontFamily: "GloriaHallelujah");

  @override
  Widget build(BuildContext context) {
    void _favorite() async {
      var session = new Session();
      var response =
          await session.get(session.url + "SwitchFavouritesServlet?fid=" + fid);
      var parsed = json.decode(response);
      print(parsed);
      setState(() {
        if (parsed["status"] == true) {
          isFavorite ? isFavorite = false : isFavorite = true;
        } else {
          //TODO
        }
      });
    }

    void _like() async {
      var session = new Session();
      var response =
          await session.get(session.url + "SwitchLikeServlet?fid=" + fid);
      var parsed = json.decode(response);
      print(parsed);
      setState(() {
        if (parsed["status"] == true) {
          isLiked ? isLiked = false : isLiked = true;
          isLiked
              ? likes = (int.parse(likes) + 1).toString()
              : likes = (int.parse(likes) - 1).toString();
        } else {
          //TODO
        }
      });
    }

    Future<void> _Downloaded(String path) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('File Downloaded at : '),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(path),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(filename),
        actions: <Widget>[
          // Like it
          IconButton(
            icon: Icon(
              Icons.thumb_up,
              color: isLiked ? Colors.blue : Colors.white,
            ),
            onPressed: _like,
            tooltip: isLiked ? "Unlike" : "Like",
          ),
          // Add to favorites
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.pink : Colors.white,
            ),
            onPressed: _favorite,
            tooltip: isFavorite ? "Remove from Favorites" : "Add to favorites",
          ),
        ],
      ),
      body: Builder(builder: (scaffoldContext) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              Center(
                child: Text(
                  filename,
                  style:
                      TextStyle(fontFamily: "GloriaHallelujah", fontSize: 24.0),
                ),
              ),
              Table(
                children: <TableRow>[
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Text(
                          "Uploaded By",
                          style: textStyle,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          uploadedBy,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Text(
                          "Total Views",
                          style: textStyle,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          views,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Text(
                          "Likes",
                          style: textStyle,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          likes,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Text(
                          "Published Year",
                          style: textStyle,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          year,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Text(
                          "Discipline",
                          style: textStyle,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          discipline,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Text(
                          "Subject",
                          style: textStyle,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          subject,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      TableCell(
                        child: Text(
                          "Institute",
                          style: textStyle,
                        ),
                      ),
                      TableCell(
                        child: Text(
                          institute,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                splashColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  String fPath = await getFile(fid, filename, 'view');
                  print(fPath);
                  if (fPath != 'Failed') {
                    FlutterPdfViewer.loadFilePath('file://' + fPath);
                  } else {
                    Scaffold.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Couldn\'t Open File')));
                  }
                },
                child: Text('Open File'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                splashColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  String fPath = await getFile(fid, filename, 'download');
                  print(fPath);
                  if (fPath == 'Failed') {
                    Scaffold.of(scaffoldContext).showSnackBar(
                        SnackBar(content: Text('Couldn\'t Download')));
                  } else {
                    _Downloaded(fPath);
                  }
                },
                child: Text('Download File'),
              ),
            ],
          ),
        );
      }),
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
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(selectedIndex: index)));
    });
  }
}
