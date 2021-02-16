import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/widgets/ProgressWidget.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {

  var data;
  var url;

  final searchEditingController = TextEditingController();
  final userRef = FirebaseFirestore.instance.collection('users');
  Future<QuerySnapshot> futureSearchResult;

  searchingFieldClear() {
    searchEditingController.clear();
  }

  controllSearching(String userName) {
    Future<QuerySnapshot> allUser =
        userRef.where("username", isEqualTo: userName).get();
    setState(() {
      futureSearchResult = allUser;
    });
  }

  AppBar searhPageHeader() {
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        cursorColor: Colors.white,
        controller: searchEditingController,

//        textCapitalization: TextCapitalization.words,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'search user .....',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            Icons.people,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey,
            ),
            onPressed: searchingFieldClear,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        onFieldSubmitted: (_) =>
            controllSearching(searchEditingController.text.trim()),
      ),
    );
  }

  Container displayNoSearchResultScreen() {
    return Container(
      child: Center(
        child: ListView(
          children: [
            Icon(
              Icons.group,
              color: Colors.grey,
              size: 200.0,
            ),
            Text(
              'Search User',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
      future: futureSearchResult,
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (ctx, index) {
              data = snapshot.data.docs[index];
              url=data['url'];
              return GestureDetector(
                onTap: (){},
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.white54,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                        backgroundImage: NetworkImage((url)),
//                        child: Image.network(data['url'])
                        ),
                    title: Text(data['username']),
                    subtitle: Text(data['email']),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: searhPageHeader(),
      body: futureSearchResult == null
          ? displayNoSearchResultScreen()
          : displayUserFoundScreen(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result here.");
  }
}
