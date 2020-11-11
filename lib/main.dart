import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  final WebSocketChannel channel = IOWebSocketChannel.connect(
      'ws://guarded-beach-93585.herokuapp.com/cable');
  @override
  _LetState createState() => _LetState();
}

class _LetState extends State<Let> {
  List<String> messageList = [];
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var width = queryData.size.width;
    var height = queryData.size.height;
    final inputcontroller = TextEditingController();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/letback.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, height * 0.1, 0, height * 0.066),
            child: Container(
              child: StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messageList.add(snapshot.data);
                  }

                  return getMessageList(context);
                },
              ),
            ),
          ),
          Positioned(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Stack(children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.006),
                      child: Container(
                        height: height * 0.055,
                        child: FloatingActionButton(
                          heroTag: 'btn2',
                          elevation: 10,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            if (inputcontroller.text.isNotEmpty) {
                              print(inputcontroller.text);
                              widget.channel.sink.add(inputcontroller.text);
                              inputcontroller.text = '';
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: width * 0.85,
                      height: height * 0.065,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.018, 0, width * 0.01, height * 0.005),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * 0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 4,
                                  blurRadius: 7,
                                  offset: Offset(
                                      1.5, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.06,
                                  height * 0.016, width * 0.06, 0),
                              child: TextField(
                                controller: inputcontroller,
                                style: TextStyle(fontSize: width * 0.06),
                                decoration: InputDecoration.collapsed(
                                  hintText: "fale merda vá",
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                ])),
          ),
          Positioned(
            child: Align(
                alignment: FractionalOffset.topCenter,
                child: Stack(children: [
                  Container(
                    height: height * 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.02, height * 0.038, 0, height * 0.008),
                      child: Image(
                        image: AssetImage("assets/marsh.png"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.04),
                      child: Text(
                        'PEPEOU',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Peu',
                            fontSize: width * 0.10),
                      ),
                    ),
                  ),
                ])),
          ),
          FloatingActionButton(
            heroTag: 'btn',
            onPressed: () {
              clear();
            },
          ),
        ],
      ),
    );
  }

  ListView getMessageList(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var height = queryData.size.height;
    List<Widget> listWidget = [];
    for (String message in messageList) {
      listWidget.add(ListTile(
        title: Container(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              message,
              style: TextStyle(fontSize: 20),
            ),
          ),
          color: Colors.white,
          height: height * 0.1,
        ),
      ));
    }
    return ListView(
      children: listWidget,
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
