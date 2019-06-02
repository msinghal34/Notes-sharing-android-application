import 'package:flutter/material.dart';
import 'session.dart';
import 'uploadFile.dart';
import 'filesDisplay.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';

class SearchFileState extends State<SearchFile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController1 = TextEditingController();
  final TextEditingController _typeAheadController2 = TextEditingController();
  final TextEditingController _typeAheadController3 = TextEditingController();
  final TextEditingController _typeAheadController4 = TextEditingController();

  final SearchCont = TextEditingController();
  final TagCont = TextEditingController();

  String tags;
  String institute;
  String discipline;
  String subject;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Search notes')),
        resizeToAvoidBottomPadding: false,
        body: Form(
            key: this._formKey,
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                padding: const EdgeInsets.all(24.0),
                children: <Widget>[
                  TextFormField(
                    key: Key('SearchStr'),
                    decoration: InputDecoration(
                      labelText: 'Search..',
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 6.0),
                    ),
                    controller: SearchCont,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                  ),
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
                      this.discipline = suggestion['label'];
                    },

                    //onSaved: (value) => this._selectedCity2 = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                  ),
                  TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController4,
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
                        this._typeAheadController4.text = suggestion['label'];
                        this.subject = suggestion['label'];
                      }),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                  ),
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: this._typeAheadController3,
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
                      this._typeAheadController3.text = suggestion['label'];
                      this.institute = suggestion['label'];
                    },

                    //onSaved: (value) => this._selectedCity3 = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                  ),
                  Builder(builder: (scaffoldContext2) {
                    return RaisedButton(
                      color: Theme.of(context).accentColor,
                      padding: const EdgeInsets.all(12.0),
                      splashColor: Theme.of(context).primaryColor,
                      child: Text('Submit'),
                      onPressed: () async {
                        if (this._formKey.currentState.validate()) {
                          this._formKey.currentState.save();
                          var sess = new Session();
                          if (SearchCont.text == null) {
                            SearchCont.text = "";
                          }
                          if (this.institute == null) {
                            this.institute = "";
                          }
                          if (this.discipline == null) {
                            this.discipline = "";
                          }
                          if (this.subject == null) {
                            this.subject = "";
                          }
                          if (_typeAheadController1.text == null) {
                            _typeAheadController1.text = "";
                          }
                          print(sess.url +
                              'SearchServlet?search_string=' +
                              SearchCont.text +
                              '&institute=' +
                              institute +
                              '&discipline=' +
                              discipline +
                              '&tag=' +
                              _typeAheadController1.text +
                              '&subject=' +
                              subject);
                          final response = await sess.get(sess.url +
                              'SearchServlet?search_string=' +
                              SearchCont.text +
                              '&institute=' +
                              institute +
                              '&discipline=' +
                              discipline +
                              '&tag=' +
                              _typeAheadController1.text);
                          final jsonO = jsonDecode(response);
                          if (jsonO['status'] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (scaffoldContext) => FilesDisplay(
                                        fList: jsonO,
                                        name: 'Search Results',
                                        sortParam: 'dontSort',
                                    selectedIndex: 1,
                                      )),
                            );
                          } else {
                            print('Logged out');
                          }
                        }
                      },
                    );
                  })
                ])));
  }
}

class SearchFile extends StatefulWidget {
  @override
  SearchFileState createState() => new SearchFileState();
}
