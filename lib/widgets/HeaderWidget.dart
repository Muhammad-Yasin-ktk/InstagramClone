import 'package:flutter/material.dart';

AppBar header(context,
    {String strTitle, bool isAppTitle = false, bool disAppearBackBtn = false}) {
  return AppBar(
    backgroundColor: Theme.of(context).accentColor,
    centerTitle: true,
    automaticallyImplyLeading: disAppearBackBtn ? false : true,
    iconTheme: IconThemeData(color: Colors.white),
    title: Text(
      isAppTitle ? 'Instagram' : strTitle,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? 'Signatra' : '',
        fontSize: isAppTitle ? 45 : 22,
      ),
      overflow: TextOverflow.ellipsis,
    ),
  );
}
