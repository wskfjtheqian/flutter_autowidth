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
    var _size = <double, int>{
      sm: 24,
      md: 12,
      lg: 8,
      xl: 6,
      ll: 4,
    };
    return Scaffold(
      body: Container(
        child: Center(
          child: Wrap(
            children: <Widget>[
              AutoWidth(
                sizes: _size,
                height: 50,
                builder: (context, constraints, useSize) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: Align(
                      alignment: useSize < lg ? Alignment.centerLeft : Alignment.centerRight,
                      child: Text(
                        "data",
                      ),
                    ),
                  );
                },
              ),
              AutoWidth(
                sizes: _size,
                height: 50,
                builder: (context, con, usixe) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: Text("data"),
                  );
                },
              ),
              AutoWidth(
                sizes: _size,
                height: 50,
                builder: (context, con, usixe) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                    ),
                    child: Text("data"),
                  );
                },
              ),
              AutoWidth(
                sizes: _size,
                height: 50,
                builder: (context, con, usixe) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                    ),
                    child: Text("data"),
                  );
                },
              ),
              AutoWidth(
                sizes: {..._size, xl: 12},
                height: 50,
                builder: (context, con, usixe) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                    ),
                    child: Text("data"),
                  );
                },
              ),
              AutoWidth(
                sizes: {..._size, xl: 12},
                height: 50,
                builder: (context, con, usixe) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      child: Text("data"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
