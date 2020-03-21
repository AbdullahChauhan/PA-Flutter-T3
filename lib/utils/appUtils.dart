import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

void progressDialog(BuildContext context, int time) {
  ProgressDialog pr = new ProgressDialog(context);
  pr.style(message: 'Please wait...');
  pr.show();
  Future.delayed(Duration(seconds: time)).then((value) {
    pr.hide().whenComplete(() {
      Navigator.of(context).pop();
    });
  });
}

navigateClearStack(BuildContext context,Widget route){
  Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => route),
      ModalRoute.withName("/ROOT")
  );
}

String readTimestamp(DateTime time, bool forWeeks) {
  var ms = time.millisecondsSinceEpoch;
  var currentTimeInSecs = (ms / 1000).round();
  var now = DateTime.now();
  // var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(currentTimeInSecs * 1000);
  var diff = now.difference(date);
  var timeStr = '';

  // time = format.format(date);

  if (diff.inSeconds <= 0 || diff.inSeconds < 60) {
    timeStr = 'Just now';
  } else if (diff.inMinutes == 0 || diff.inMinutes < 60) {
    if (diff.inMinutes == 1) {
      timeStr = diff.inMinutes.toString() + ' min';
    } else {
      timeStr = diff.inMinutes.toString() + ' mins';
    }
  } else if (diff.inHours == 0 || diff.inHours < 60 && diff.inDays == 0) {
    if (diff.inHours == 1) {
      timeStr = diff.inHours.toString() + ' hr';
    } else {
      timeStr = diff.inHours.toString() + ' hrs';
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      timeStr = diff.inDays.toString() + ' day';
    } else {
      timeStr = diff.inDays.toString() + ' days';
    }
  } else if (forWeeks) {
    if (diff.inDays == 7) {
      timeStr = (diff.inDays / 7).floor().toString() + ' week ago';
    } else {
      timeStr = (diff.inDays / 7).floor().toString() + ' weeks ago';
    }
  } else {
    timeStr = DateFormat.yMMMMd().format(date);
  }
  return timeStr;
}
