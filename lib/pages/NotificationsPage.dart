import 'package:flutter/material.dart';
import 'package:instagramclone/widgets/HeaderWidget.dart';
import 'package:instagramclone/widgets/ProgressWidget.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: 'Notifiacation'),
      body: linearProgress(),
    );
  }
}

class NotificationsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Activity Feed Item goes here');
  }
}
