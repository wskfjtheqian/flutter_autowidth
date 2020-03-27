import 'package:flutter/material.dart';
import 'package:flutter_aoutwidth/flutter_aoutwidth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AutoWidhtTheme(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
            child: Text("data"),
            onTap: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Wrap(
            children: <Widget>[
              AutoWidth(
                sizes: <double, int>{
                  xl: 8,
                  lg: 12,
                  sm: 24,
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                  ),
                  child: Text("data"),
                ),
              ),
              AutoWidth(
                sizes: <double, int>{
                  xl: 8,
                  lg: 12,
                  sm: 24,
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Text("data"),
                ),
              ),
              AutoWidth(
                sizes: <double, int>{
                  xl: 8,
                  lg: 24,
                  sm: 24,
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                  ),
                  child: Text("data"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
