import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
      ),
    ),
  );
}

linearProgress() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40),
    child: Center(
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
      ),
    ),
  );
}
