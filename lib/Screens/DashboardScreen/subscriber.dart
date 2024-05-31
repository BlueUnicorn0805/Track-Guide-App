// import 'package:flutter/cupertino.dart';
//
// import 'DashboardScreen.dart';
//
// final List<NewBooks> data;
// SubscriberChart({required this.data});
// @override
// Widget build(BuildContext context) {
//   List<charts.Series<NewBooks, String>> series= [charts.Series(id:"Subscribers" ,data: data,domainFn: (NewBooks series, _) => series.year,measureFn: (NewBooks series, _) =>series.books,colorFn: (NewBooks series, _) =>series.barColor,),
//   ];