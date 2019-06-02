import 'package:flutter/material.dart';
import 'session.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadPageState createState() => new _UploadPageState();
}

class _UploadPageState extends State<UploadFile> {
  String _filePath;
  final TextEditingController _typeAheadController1 = TextEditingController();

  final TextEditingController _typeAheadController2 = TextEditingController();
  final TextEditingController _typeAheadController3 = TextEditingController();
  final TextEditingController _typeAheadController4 = TextEditingController();
  final Yearcont = TextEditingController();
  final fileNameCont = TextEditingController();
  final tagCont = TextEditingController();

  void getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.PDF);
      if (filePath == '') {
        return;
      }
      setState(() {
        this._filePath = filePath;
      });
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: new Text('Upload File'),
        ),
        body: Builder(builder: (scaffoldContext) {
          return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              padding: const EdgeInsets.all(24.0),
              children: <Widget>[
                FloatingActionButton(
                  onPressed: getFilePath,
                  tooltip: 'Select file',
                  child: new Icon(Icons.sd_storage),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                Center(
                  child: _filePath == null
                      ? new Text('No file selected.')
                      : new Text('Path' + _filePath),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                //Text('Enter filename:'),
                TextFormField(
                  key: Key('file_name'),
                  decoration: InputDecoration(
                    labelText: 'Topic',
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 6.0),
                  ),
                  controller: fileNameCont,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter topic';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                //Text('Enter tags:'),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController1,
                      decoration: InputDecoration(labelText: 'Tags',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 6.0),)),
                  suggestionsCallback: (pattern) async {
                    var sess = new Session();
                    List<String> tagList= pattern.split(',');

                    final citiesJson = await sess.get(sess.url + 'AutoCompleteTag?tag='+tagList[tagList.length -1]);
                    return json.decode(citiesJson);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['label']),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    List<String> tagList = this._typeAheadController1.text.split(',');
                    tagList.removeLast();
                    this._typeAheadController1.text = tagList.join(",");
                    if(tagList.isNotEmpty){
                      this._typeAheadController1.text += ',';
                    }
                    this._typeAheadController1.text += suggestion['label'] +',';
                  },

                  //onSaved: (value) => this._selectedCity1 = value,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                //Text('Enter discipline:'),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController2,
                      decoration: InputDecoration(
                        labelText: 'Discipline',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 6.0),
                      )),
                  suggestionsCallback: (pattern) async {
                    var sess = new Session();

                    final citiesJson = await sess.get(sess.url +
                        'AutoCompleteDiscipline?discipline=' +
                        pattern);
                    print(citiesJson);
                    return json.decode(citiesJson);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['label']),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController2.text = suggestion['label'];
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a discipline';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                // Text('Enter subject:'),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController3,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 6.0),
                      )),
                  suggestionsCallback: (pattern) async {
                    var sess = new Session();
                    final citiesJson = await sess.get(sess.url +
                        'AutoCompleteSubject?subject=' +
                        pattern +
                        '&discipline=' +
                        this._typeAheadController2.text);
                    return json.decode(citiesJson);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['label']),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController3.text = suggestion['label'];

                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select a subject';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                //Text('Enter institute:'),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: this._typeAheadController4,
                      decoration: InputDecoration(
                        labelText: 'Institute',
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 6.0),
                      )),
                  suggestionsCallback: (pattern) async {
                    var sess = new Session();
                    final citiesJson = await sess.get(sess.url +
                        'AutoCompleteInstitute?institute=' +
                        pattern);
                    return json.decode(citiesJson);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['label']),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (suggestion) {
                    this._typeAheadController4.text = suggestion['label'];

                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please select an institute';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                //Text('Enter year:'),
                TextFormField(
                  key: Key('Year'),
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 6.0),
                  ),
                  controller: Yearcont,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter search string';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                ),
                RaisedButton(
                    child: Text('Upload'),
                    onPressed: () async {

                      if(fileNameCont.text == null || fileNameCont.text == "") {Scaffold.of(scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Topic not entered!'))); return;}
                      else if (_filePath == null || _filePath == "") {
                        Scaffold.of(scaffoldContext).showSnackBar(
                            SnackBar(content: Text('File not selected!'))); return;
                      }
                      else if(this._typeAheadController4.text == null || this._typeAheadController4.text == "") {
                        Scaffold.of(scaffoldContext).showSnackBar(
                            SnackBar(content: Text('Institute not entered!')));
                        return;}
                      else if(this._typeAheadController2.text == null || this._typeAheadController2.text == "")  {Scaffold.of(scaffoldContext).showSnackBar(
                          SnackBar(content: Text('Discipline not entered!'))); return;}
                      else if(this._typeAheadController3.text == null || this._typeAheadController3.text == "") {Scaffold.of(scaffoldContext).showSnackBar(
                          SnackBar(content: Text('is null!'))); return;}
                      else if(Yearcont.text == null || Yearcont.text == "") {Scaffold.of(scaffoldContext).showSnackBar(
                          SnackBar(content: Text('Year not entered'))); return;}

                      else{
                        Session a = new Session();

                        var uri = Uri.parse(a.url + 'FileUploadServlet_Ashutosh');
                        var request = new http.MultipartRequest("POST", uri);
                        for (String s in a.headers.keys) {
                          print(s + " " + a.headers[s]);
                          request.headers[s] = a.headers[s];
                        }
                        var mType = new MediaType('multipart/form-data', 'pdf');
                        var multipartFile = await http.MultipartFile.fromPath(
                            "upload", _filePath,
                            filename: basename(_filePath), contentType: mType);
                        request.files.add(multipartFile);
                        request.fields['year'] = Yearcont.text;
                        request.fields['file_name'] = fileNameCont.text;




                        if(this._typeAheadController1.text == null) this._typeAheadController1.text="";


                        request.fields['tags'] = this._typeAheadController1.text;
                        request.fields['institute'] =  this._typeAheadController4.text;
                        request.fields['discipline'] = this._typeAheadController2.text ;
                        request.fields['subject'] = this._typeAheadController3.text;
                        print(request.toString());
                        request.send().then((response) {
                          if (response.statusCode == 200) {
                            response.stream.bytesToString().then((value) {print(value);});
                            print("Uploaded!");
                            print(response);
                            Scaffold.of(scaffoldContext).showSnackBar(
                                SnackBar(content: Text('Uploaded!')));
                          } else {
                            Scaffold.of(scaffoldContext).showSnackBar(
                                SnackBar(content: Text('Failed to upload!')));
                          }
                        }
                        );}

                    })
              ]);
        }));
  }
}
