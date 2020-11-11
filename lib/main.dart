import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with AfterLayoutMixin<Screen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    String _seen = '';
    _seen = prefs.getString('seen');

    if (_seen == 'peu') {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Peu()));
    } else if (_seen == 'let') {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Let()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/initback.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: null /* add child content here */,
      ),
    );
  }
}

class Let extends StatefulWidget {
  @override
  _LetState createState() => _LetState();
}

class _LetState extends State<Let> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: Colors.red),
        FloatingActionButton(
          onPressed: () {
            clear();
          },
        )
      ],
    );
  }

  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

class Peu extends StatefulWidget {
  @override
  _PeuState createState() => _PeuState();
}

class _PeuState extends State<Peu> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: Colors.blue),
        FloatingActionButton(
          onPressed: () {
            clear();
          },
        )
      ],
    );
  }

  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var width = queryData.size.width;
    var height = queryData.size.height;

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/initback.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/bee.png"),
                  width: width * 0.3,
                ),
                Text(
                  'beinha',
                  style: TextStyle(fontFamily: 'Bee', fontSize: width * 0.25),
                ),
                Container(height: height * 0.05),
                GestureDetector(
                  onTap: () {
                    route('let', context);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: width * 0.8,
                        height: height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'lequinha',
                        style: TextStyle(
                            fontFamily: 'Let', fontSize: width * 0.15),
                      ),
                    ],
                  ),
                ),
                Container(height: height * 0.05),
                GestureDetector(
                  onTap: () {
                    route('peu', context);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: width * 0.8,
                        height: height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'PEPEOU',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Peu',
                            fontSize: width * 0.15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> route(String rota, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('seen', rota);
    Widget destiny;

    if (rota == 'peu') {
      destiny = Peu();
    } else {
      destiny = Let();
    }

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => destiny));
  }
}
