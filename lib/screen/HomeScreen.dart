import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:vahak_assesment/http/api.dart';
import 'package:vahak_assesment/screen/WebViewScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SearchBar searchBar;
  List dataList = [];
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    searchBar = SearchBar(
      inBar: false,
      setState: setState,
      onSubmitted: (str) {
        setState(() {
          showLoader = true;
        });
        syncData(str);
      },
      buildDefaultAppBar: buildAppBar,
      hintText: 'Search',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          width: MediaQuery.of(context).size.width,
          child: dataList.isEmpty
              ? Center(
                  child: showLoader
                      ? CircularProgressIndicator()
                      : Text(
                          'Search wikipedia...',
                          style: TextStyle(fontSize: 20.0),
                        ),
                )
              : Container(
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 30,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 80.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: true,
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5.0,
                            child: ListTile(
                              leading: dataList[index].containsKey('thumbnail')
                                  ? CircleAvatar(
                                      foregroundImage: NetworkImage(dataList[index]['thumbnail']['source']),
                                    )
                                  : CircleAvatar(
                                      child: Text(
                                        dataList[index]['title'].substring(0, 2),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Theme.of(context).accentColor,
                                    ),
                              title: Text(dataList[index]['title']),
                              subtitle: dataList[index].containsKey('terms') ? Text(dataList[index]['terms']['description'][0]) : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                      url: dataList[index]['title'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Home'),
      elevation: 5.0,
      iconTheme: IconThemeData(color: Colors.white),
      // toolbarHeight: 50.0,
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  syncData(String str) async {
    List lst = await Api.wikiRequest(context, str);
    setState(() {
      dataList.clear();
      dataList.addAll(lst);
    });
    print(dataList);
    setState(() {
      showLoader = false;
    });
  }
}
