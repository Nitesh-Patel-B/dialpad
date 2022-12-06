import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dialpad/DBhelper.dart';
import 'package:dialpad/NewSchedule.dart';
import 'package:dialpad/addlist.dart';
import 'package:dialpad/Schedule.dart';
import 'package:dialpad/recent.dart';
import 'package:dialpad/update3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MaterialApp(
    home: dialpad(),
    debugShowCheckedModeBanner: false,
  ));
}

class dialpad extends StatefulWidget {
  const dialpad({Key? key}) : super(key: key);

  @override
  State<dialpad> createState() => _dialpadState();
}

class _dialpadState extends State<dialpad> {
  Database? db;
  List<Map> mm = [];
  int liveindex = 0;
  String DisplayView = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getalldata();
  }

  getalldata() {
    DBhelper().Getedatabase().then((value) {
      setState(() {
        db = value;
      });
      DBhelper().viewdata(db!).then((listofmap) {
        setState(() {
          mm = listofmap;
        });
      });
    });
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IndexedStack(
        index: liveindex,
        children: [
          const Chat(),
          Recent(key: UniqueKey()),
          const Keypad(),
          Schedule(key: UniqueKey()),
          const Setting(),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.grey,
        currentIndex: liveindex,
        unselectedItemColor: Colors.grey.shade900,
        selectedItemColor: Colors.blue,
        onTap: (int index) => setState(() => liveindex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Chat Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Recents'),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: 'Keypad'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_sharp), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

//TODO chat
class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double th = MediaQuery.of(context).size.height;
    double tw = MediaQuery.of(context).size.width;
    double sth = MediaQuery.of(context).padding.top;
    double nvh = MediaQuery.of(context).padding.bottom;
    // double aph=kToolbarHeight;
    double bh = th - sth - nvh;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Chat Tools",
                    style: TextStyle(
                        fontSize: tw * 0.05, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
          Container(
            height: bh * 0.1,
            width: tw * 0.9,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.lightGreen),
            child: InkWell(
              onTap: () {
                var url = Uri.parse('https://web.whatsapp.com');
                launchUrl(url);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(left: tw * 0.01, top: bh * 0.01),
                      child: Image.asset(
                        'images/w.jpg',
                        height: th * 0.1,
                      )),
                  SizedBox(
                      child: Text("WhatsApp Web  ",
                          style: TextStyle(fontSize: tw * 0.06))),
                  SizedBox(
                      child: Text(
                    "Open",
                    style:
                        TextStyle(fontSize: tw * 0.08, color: Colors.white70),
                  )),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

//TODO keypad
class Keypad extends StatefulWidget {
  const Keypad({Key? key}) : super(key: key);

  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  Database? db;
  DateTime dt = DateTime.now();
  TimeOfDay td = TimeOfDay.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatabase();
    inapp();
  }

  Future<void> inapp() async {}

  getdatabase() {
    DBhelper().Getedatabase().then((value) {
      setState(() {
        db = value;
      });
    });
  }

  String ViewDisplay = "";
  String Null = '';
  TextEditingController nm = TextEditingController();
  TextEditingController msg = TextEditingController();
  String name = '';
  String mssg = '';

  //TODO Widget

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var Android = "$name " "$mssg";
    double th = MediaQuery.of(context).size.height;
    double tw = MediaQuery.of(context).size.width;
    double sth = MediaQuery.of(context).padding.top;
    double nvh = MediaQuery.of(context).padding.bottom;
    // double aph=kToolbarHeight;
    double bh = th - sth - nvh;

    return Scaffold(
      // backgroundColor: Colors.black12,
      body: SafeArea(
          child: SizedBox(
        height: bh * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                margin: EdgeInsets.only(left: tw * 0.06, top: bh * 0.1),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(1),

                      //TODO Country_Code_Picker
                      child: SizedBox(
                        width: tw * 0.27,
                        height: bh * 0.05,
                        child: CountryCodePicker(
                          padding: const EdgeInsets.all(0),
                          onChanged: (e) => print(e.toLongString()),
                          initialSelection: 'IN',
                          dialogSize: const Size(double.infinity, 600),
                          dialogBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.white30,
                          alignLeft: true,
                          flagWidth: tw * 0.07,
                          dialogTextStyle: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: bh * 0.04),
                          favorite: const ['+91', 'IN'],
                        ),
                      ),
                    ),

                    //TODO Display
                    SizedBox(
                      width: tw * 0.65,
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {},
                            onLongPress: () {
                              FlutterClipboard.paste()
                                  .then((value) => const Text("paste"));
                            },
                            child: Text(
                              ViewDisplay,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: tw * 0.09,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: bh * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: tw * 0.03),

                    //TODO Enter Name
                    child: InkWell(
                      child: name.isNotEmpty
                          ? Text(
                              name,
                              style: const TextStyle(color: Colors.blue),
                            )
                          : Text("Enter Name",
                              style: TextStyle(
                                  color: Colors.blue, fontSize: bh * 0.03)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Enter Name',
                                  style: TextStyle(
                                      fontSize: bh * 0.03, color: Colors.blue)),
                              content: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                controller: nm,
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "cancel",
                                      style: TextStyle(fontSize: bh * 0.03),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      // String nname = ViewDisplay;
                                      // String msgg = msg.text;
                                      // String nnum = ViewDisplay;
                                      //
                                      // print(nname);

                                      // await DBhelper().insertdata(
                                      //     nname, nnum, msgg, db!);
                                      // .insertdata(nname, nnum, db!);
                                      //     .then((value) {
                                      //   Navigator.pushReplacement(context,
                                      //       MaterialPageRoute(
                                      //     builder: (context) {
                                      //       return Keypad();
                                      //     },
                                      //   ));
                                      // });

                                      setState(() {
                                        name = nm.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Add",
                                      style: TextStyle(fontSize: bh * 0.03),
                                    )),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: tw * 0.01),
                  Text(
                    "|",
                    style: TextStyle(fontSize: bh * 0.04),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: tw * 0.03),

                    //TODO Enter Name
                    child: InkWell(
                      child: mssg.isNotEmpty
                          ? Text(
                              mssg,
                              style: TextStyle(
                                  color: Colors.blue, fontSize: bh * 0.03),
                            )
                          : Text("Enter Message",
                              style: TextStyle(
                                  color: Colors.blue, fontSize: bh * 0.03)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('enter Message',
                                  style: TextStyle(
                                      fontSize: bh * 0.03, color: Colors.blue)),
                              content: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                controller: msg,
                                onChanged: (value) {
                                  setState(() {
                                    mssg = value;
                                  });
                                },
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "cancel",
                                      style: TextStyle(fontSize: bh * 0.03),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      // String nname = ViewDisplay;
                                      // String msgg = msg.text;
                                      // String nnum = ViewDisplay;
                                      //
                                      // print(nname);

                                      // await DBhelper().insertdata(
                                      //     nname, nnum, msgg, db!);
                                      // .insertdata(nname, nnum, db!);
                                      //     .then((value) {
                                      //   Navigator.pushReplacement(context,
                                      //       MaterialPageRoute(
                                      //     builder: (context) {
                                      //       return Keypad();
                                      //     },
                                      //   ));
                                      // });

                                      setState(() {
                                        name = nm.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Add",
                                      style: TextStyle(fontSize: bh * 0.03),
                                    )),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                dialPadButton(size, '1', '+91'),
                dialPadButton(size, '2', 'ABC'),
                dialPadButton(size, '3', 'DEF')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                dialPadButton(size, '4', 'GHI'),
                dialPadButton(size, '5', 'JKL'),
                dialPadButton(size, '6', 'MNO')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                dialPadButton(size, '7', 'PQRS'),
                dialPadButton(size, '8', 'TUV'),
                dialPadButton(size, '9', 'WXYZ')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                      height: bh * 0.1,
                      width: tw * 0.2,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(100)),
                      child: const Icon(Icons.copy)),
                  onTap: () {
                    if (ViewDisplay == Null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.black87,
                          content: Text(
                            "Please Enter Number",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.green),
                          )));
                    } else if (name.isNotEmpty && mssg.isNotEmpty) {
                      FlutterClipboard.copy("$ViewDisplay" "\n$name" "\n$mssg")
                          .then((value) => print("Copied Succeed"));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("All Copied",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green))));
                    } else if (ViewDisplay != 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Number Copied",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green))));
                    }
                  },
                ),
                dialPadButton(size, '0', '+'),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: bh * 0.1,
                    width: tw * 0.2,
                    alignment: Alignment.center,
                    //margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        // color: Colors.orangeAccent,
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Icon(Icons.backspace_outlined),
                  ),
                  onLongPress: () {
                    setState(() {
                      ViewDisplay = Null;
                    });
                  },
                  onTap: () {
                    if (ViewDisplay.isNotEmpty) {
                      setState(() {
                        ViewDisplay =
                            ViewDisplay.substring(0, ViewDisplay.length - 1);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.only(
                              top: 10, right: 10, left: 10, bottom: 5),
                          content: Text(
                            "Already Deleted",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
                          )));
                    }
                  },
                ),
              ],
            ),

            // TODO Button call
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: tw * 0.1),
                  height: bh * 0.1,
                  width: tw * 0.23,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black12),
                  child: InkWell(
                    child: Center(
                      child: IconButton(
                          onPressed: () async {
                            String nnum = ViewDisplay;
                            String nname = nm.text;
                            String msgg = msg.text;
                            String datee =
                                "${td.hour.remainder(12).toString().padLeft(2, '0')}:${td.minute.toString().padLeft(2, '0')} ${td.period.name}  "
                                "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
                            await DBhelper()
                                .insertdata(nname, nnum, msgg, datee, db!);
                            // .insertdata(nname, nnum, db!);

                            FlutterPhoneDirectCaller.callNumber(ViewDisplay);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                      "Calling....",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.green),
                                    )));
                          },
                          icon: const Icon(
                            Icons.call,
                            size: 36,
                          )),
                    ),
                  ),
                ),

                //TODO whatsapp
                Container(
                  height: bh * 0.1,
                  width: tw * 0.2,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black12),
                  child: InkWell(
                      onLongPress: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return const Recent();
                          },
                        ));
                      },
                      child: Center(
                        child: IconButton(
                            onPressed: () async {
                              if (kDebugMode) {
                                print(inapp());
                              }

                              var whatsappUrl =
                                  "whatsapp://send?phone=+91$ViewDisplay"
                                  "&text=$Android";
                              var instalwhatsapp =
                                  "https://play.google.com/store/apps/details?id=com.whatsapp";

                              // "&text=${Uri.encodeComponent(Android)}";

                              if (ViewDisplay.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                          "Please Enter Number",
                                          style: TextStyle(color: Colors.blue),
                                        )));
                              } else {
                                if (ViewDisplay.isNotEmpty) {
                                  launchUrl(Uri.parse(whatsappUrl));
                                  //  launch(whatsappUrl);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                    "WhatsApp Direct",
                                    style: TextStyle(color: Colors.blue),
                                  )));
                                } else {
                                  launchUrl(Uri.parse(instalwhatsapp));
                                  // launch();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Installing WhatsApp")));
                                }
                              }

                              // try {
                              //   launchUrl(Uri.parse(whatsappUrl));
                              //   // launch(whatsappUrl);
                              //   ScaffoldMessenger.of(context)
                              //       .showSnackBar(SnackBar(
                              //           backgroundColor: Colors.transparent,
                              //           duration: Duration(seconds: 2),
                              //           content: Text(
                              //             "Sharing on WhatsApp",
                              //             style: TextStyle(
                              //                 color: Colors.black),
                              //           )));
                              // } catch (e) {
                              //   var instalwhatsapp =
                              //       "https://play.google.com/store/apps/details?id=com.whatsapp";
                              //   launchUrl(Uri.parse(instalwhatsapp));
                              //   // launch(instalwhatsapp);
                              //   //To handle error and display error message
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //           content: Text("WhatsApp Direct")));
                              // }
                            },
                            icon: const Icon(
                              Icons.whatsapp,
                              size: 35,
                            )),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(right: tw * 0.1),
                  height: bh * 0.1,
                  width: tw * 0.2,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black12),
                  child: InkWell(
                    child: const Center(
                      child: Icon(
                        Icons.share,
                        size: 35,
                      ),
                    ),
                    onTap: () {
                      Share.share("$ViewDisplay " "$mssg " "$name");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

//TODO Widget
  Widget dialPadButton(Size size, String value, String valuee, {Color? color}) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return InkWell(
      highlightColor: Colors.green,
      onLongPress: () {
        setState(() {
          ViewDisplay = ViewDisplay + valuee;
        });
      },
      onTap: () {
        setState(() {
          ViewDisplay = ViewDisplay + value;
        });
      },
      child: Container(
        height: h * 0.1,
        width: w * 0.2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            value,
            textScaleFactor: 1.0,
            style: TextStyle(
                color: color ?? Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

//TODO schedule
class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  stt.SpeechToText speech = stt.SpeechToText();
  bool onlisn = false;
  String lisned = '';

  void ononlisn() async {
    if (!onlisn) {
      bool available = await speech.initialize(
          onStatus: (val) => print('listening : $val'),
          onError: (val) => print('not listening: $val'));
      if (available) {
        if (mounted) {
          setState(() {
            onlisn = true;
          });
        }
        speech.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                lisned = result.recognizedWords;
              });
            }
          },
        );
        // onResult: (val) => setState(() {
        //       lisned = val.recognizedWords;
        //     }));
      }
    } else {
      if (mounted) {
        setState(() {
          onlisn = false;
          speech.stop();
        });
      }
    }
  }

  Database? dbb;
  Database? dbbb;
  List<Map> mp = [];
  List<Map> mpp = [];
  SharedPreferences? pre;
  bool? values;
  List<Map> searchlist = [];
  bool issearch = false;
  CalendarFormat format = CalendarFormat.month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    speech = stt.SpeechToText();
    if (kDebugMode) {
      print("radio working$values");
      getdataa();
    }
  }

  getdataa() {
    Dbhelper().Getdatabs().then((values) {
      setState(() {
        dbbb = values;
      });
      Dbhelper().viewdataa(dbbb!).then((listmap) {
        setState(() {
          mpp = listmap;
          searchlist = listmap;

          // for (int i = 0; i < mpp.length; i++) {
          //   var a = mpp[i].values.toString();
          //   var o = mpp[i].keys.toString();
          //   if (kDebugMode) {
          //     print("printttttqqqqqqqqqqqqqqqtt$a");
          //     print("printttttqqqqqqqqqqqqqqqtt$o");
          //   }
          // }
        });
      });
      return Future.value();
    });
  }

  getdata() {
    Dbhelper().Getdatabs().then((value) {
      if (mounted) {
        setState(() {
          dbb = value;
        });
      }
      // Dbhelper().viewdata(,dbb!).then((valuelistmap) {
      //   if (mounted) {
      //     setState(() {
      //       mp = valuelistmap;
      //     });
      //   }
      // });
    });
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    TextEditingController(text: onlisn == false ? '' : lisned);

    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(backgroundColor: Colors.white60, actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    values = false;

                    return Event();
                  },
                ));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.blue,
                size: 30,
              ))
        ]),
        key: GlobalKey(),
        body:
            // mp.isNotEmpty
            // ?
            SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      "Schedule",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  ],
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                SizedBox(
                  height: h * 0.07,
                  width: w * 0.95,
                  child: TextField(
                    onChanged: (value) {
                      if (kDebugMode) {
                        print("key press: $value");
                      }
                      // if (mounted) {
                      setState(() {
                        if (value.isNotEmpty) {
                          searchlist = [];
                          for (int i = 0; i < mpp.length; i++) {
                            String numm = mpp[i]['names'];
                            if (numm
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              searchlist.add(mpp[i]);
                            }
                          }
                        } else if (lisned.isNotEmpty) {
                          searchlist = [];
                          for (int i = 0; i < mpp.length; i++) {
                            String nmm = mpp[i]['names'];
                            if (nmm
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              searchlist.add(mpp[i]);
                            }
                          }
                        } else {
                          searchlist = mpp;
                        }
                      });

                      // }
                    },
                    decoration: InputDecoration(
                        hintText: onlisn == false ? 'Search' : 'Speak Now...',
                        suffixIcon: AvatarGlow(
                            animate: onlisn,
                            glowColor: Theme.of(context).primaryColor,
                            duration: const Duration(milliseconds: 2000),
                            // repeatPauseDuration: Duration(seconds: 1),
                            repeat: true,
                            endRadius: 40,
                            child: IconButton(
                                onPressed: () => ononlisn(),
                                icon:
                                    Icon(onlisn ? Icons.mic : Icons.mic_none))),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                // TableCalendar(
                //     onFormatChanged: (fformat) {
                //       if (mounted) {
                //         setState(() {
                //           fformat = format;
                //         });
                //       }
                //     },
                //     calendarFormat: CalendarFormat.week,
                //     focusedDay: DateTime.now(),
                //     firstDay: DateTime.utc(2000),
                //     lastDay: DateTime.utc(2050)),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "My List",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                        ),
                        SizedBox(width: w * 0.5),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Addlist();
                                  },
                                ));
                              },
                              child: Text(
                                "Add List",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.green),
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: h * 0.04),
                    SizedBox(
                      height: h * 0.63,
                      width: w * 1,
                      child: ListView.builder(
                        itemCount: issearch ? mpp.length : searchlist.length,
                        itemBuilder: (context, index) {
                          Map mapp = issearch ? mpp[index] : searchlist[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  // Map map=mpp[index];
                                  // String map=mpp as String;
                                  // String list=map;
                                  // String list=map['names'];
                                  int list = mpp[index]['listid'];
                                  return Eventlist(list);
                                },
                              ));
                            },
                            child: Slidable(
                                endActionPane: ActionPane(
                                    motion: BehindMotion(),
                                    children: [
                                      SizedBox(
                                        width: 30,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              int idd = mpp[index]['listid'];
                                              Dbhelper().deletdataa(dbbb!, idd);
                                            });
                                          },
                                          child: Text(
                                            'Delete',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            int idd = mpp[index]['listid'];
                                            String nam = mpp[index]['names'];
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return Listtupdt(idd, nam);
                                              },
                                            ));
                                          },
                                          child: Text(
                                            'Edit',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                    ]),
                                child: Card(
                                  color: Colors.black12,
                                  child: ListTile(
                                    title: Text('${mapp['names']}'),
                                  ),
                                )),
                          );
                        },
                      ),
                    )
                  ],
                )

                //TODO start database
                // SizedBox(
                //   height: h * 0.391,
                //   child: ListView.builder(
                //     itemCount: iss ? mp.length : search.length,
                //     itemBuilder: (context, index) {
                //       Map map = iss ? mp[index] : search[index];
                //
                //       return InkWell(
                //         onTap: () {
                //           int id = mp[index]['id'];
                //           String name = mp[index]['namew'];
                //           String number = mp[index]['numberw'];
                //           String msgg = mp[index]['messagew'];
                //           String title = mp[index]['title'];
                //           String imes = mp[index]['imagew'];
                //           String ttime = mp[index]['datew'];
                //
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => Update(imes, id,
                //                     name, number, msgg, title, ttime),
                //               ));
                //         },
                //         onLongPress: () {},
                //         child: Card(
                //           child: ListTile(
                //             // leading: Image.asset(imi),
                //             leading: SizedBox(
                //                 height: h * 0.1,
                //                 width: w * 0.15,
                //                 child:
                //
                //                     // Text("${mp[index]['datew']}")
                //                     Image.asset(mp[index]['imagew'])),
                //             // leading: ?Image.asset("images/whatsapp.png"):Image.asset("images/message.jpg"),
                //             title: Text("${map['title']}",
                //                 style: const TextStyle(
                //                     fontSize: 25,
                //                     color: Colors.black,
                //                     fontWeight: FontWeight.bold,
                //                     fontStyle: FontStyle.italic)),
                //             subtitle: Container(
                //               child: Text(
                //                 "${mp[index]['numberw']}(${mp[index]['namew']})${mp[index]['datew']}",
                //                 style: const TextStyle(fontSize: 20),
                //               ),
                //             ),
                //             trailing: Container(
                //               child: PopupMenuButton(
                //                 onSelected: (value) {
                //                   if (value == 1) {
                //                     int id = mp[index]['id'];
                //                     String name = mp[index]['namew'];
                //                     String number = mp[index]['numberw'];
                //                     String msgg = mp[index]['messagew'];
                //                     String title = mp[index]['title'];
                //                     String imes = mp[index]['imagew'];
                //                     String ttime = mp[index]['datew'];
                //
                //                     Navigator.push(context,
                //                         MaterialPageRoute(
                //                       builder: (context) {
                //                         return Update(imes, id, name,
                //                             number, msgg, title, ttime);
                //                       },
                //                     ));
                //                   }
                //                 },
                //                 itemBuilder: (context) {
                //                   return [
                //                     PopupMenuItem(
                //                         value: 0,
                //                         textStyle: const TextStyle(
                //                             color: Colors.redAccent),
                //                         height: h * 0.1,
                //                         onTap: () {
                //                           int id = mp[index]['id'];
                //                           Dbhelper().deletdata(dbb!, id);
                //                         },
                //                         child: const Icon(Icons.delete)),
                //                     PopupMenuItem(
                //                         onTap: () {},
                //                         textStyle: const TextStyle(
                //                             color: Colors.blue),
                //                         height: h * 0.1,
                //                         value: 1,
                //                         child: const Icon(Icons.update)),
                //                     PopupMenuItem(
                //                         onTap: () {
                //                           dbb!.delete('Schedule');
                //                           if (kDebugMode) {
                //                             print("All Deleted");
                //                           }
                //                         },
                //                         child: const Text("DeleteAll"))
                //                   ];
                //                 },
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                //TODO end

                // TableCalendar(
                //     calendarStyle: CalendarStyle(isTodayHighlighted: true),
                //     daysOfWeekVisible: true,
                //     startingDayOfWeek: StartingDayOfWeek.monday,
                //     focusedDay: DateTime.now(),
                //     firstDay: DateTime(1990),
                //     lastDay: DateTime(2050)),

                // Container(child: ListView(),)
              ],
            ),
          ),
        )
        // : Scaffold(
        //     body: SingleChildScrollView(
        //       // padding: EdgeInsets.only(top: h * 0.1),
        //       // height: h * 0.8,
        //       child: Column(
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               SizedBox(
        //                 height: h * 0.1,
        //               ),
        //               const Text(
        //                 "No Schedule",
        //                 style: TextStyle(
        //                     fontStyle: FontStyle.italic,
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 30),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             children: [
        //               SizedBox(
        //                   height: h * 0.5,
        //                   width: w * 1,
        //                   child:
        //                       Lottie.asset('images/104954-calendar.json')),
        //             ],
        //           ),
        //           Column(
        //             children: const [
        //               Text(
        //                   "Your Schedule is Empty. Click Add +Button to create a new Schedule."),
        //             ],
        //           )
        //         ],
        //       ),
        //     ),
        //   )
        );
  }
}

//TODO setting

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    double th = MediaQuery.of(context).size.height;
    double tw = MediaQuery.of(context).size.width;
    double sth = MediaQuery.of(context).padding.top;
    double nvh = MediaQuery.of(context).padding.bottom;
    double aph = kToolbarHeight;
    double bh = th - sth - aph - nvh;
    return Scaffold(
        body: SafeArea(
            child: Container(
      margin: EdgeInsets.only(top: bh * 0.03, left: tw * 0.05),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Setting",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: tw * 0.07),
              )
            ],
          ),
          SizedBox(
            height: th * 0.1,
          ),
          InkWell(
            onTap: () {
              var rate = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.ligerinfotech.clicktochats');
              launchUrl(rate);
            },
            child: Container(
              color: Colors.black12,
              height: bh * 0.07,
              child: Row(
                children: [
                  Image.asset('images/love.jpg', height: bh * 0.05),
                  const Text(
                    "   Rate Us",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: bh * 0.01),

          InkWell(
            onTap: () {
              String l = '91';
              var sr = Uri.parse("whatsapp://send?phone=$l");
              launchUrl(sr);
            },
            child: Container(
              color: Colors.black12,
              height: bh * 0.07,
              child: Row(
                children: [
                  Image.asset('images/share.png', height: th * 0.05),
                  Text(
                    "   Share App",
                    style: TextStyle(fontSize: tw * 0.05),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: th * 0.01),

          InkWell(
            onTap: () {
              var help = Uri.parse(
                  'mailto:manufacturingbiss@gmail.com?subject=Help&body=Feedback for ClickToChat App Android');
              launchUrl(help);
            },
            child: Container(
              color: Colors.black12,
              height: bh * 0.07,
              child: Row(
                children: [
                  Image.asset('images/help.webp', height: th * 0.057),
                  const Text(
                    " Help",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: th * 0.01),
          // Container(color: Colors.black12, height: th * 0.01),
          SizedBox(height: th * 0.003),
          InkWell(
            onTap: () {
              var url = Uri.parse(
                  "https://play.google.com/store/apps/dev?id=8412834193356581377");
              launchUrl(url);
            },
            child: Container(
              color: Colors.black12,
              height: bh * 0.07,
              child: Row(
                children: [
                  Image.asset('images/app.png', height: th * 0.035),
                  const Text(
                    " More App",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: th * 0.1),

          Container(
            color: Colors.black12,
            height: bh * 0.07,
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Image.asset('images/pv.jpg', height: th * 0.05),
                  const Text(
                    "  Our Privacy Policy",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: th * 0.01),

          Container(
            color: Colors.black12,
            height: bh * 0.07,
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Image.asset('images/img.png', height: th * 0.05),
                  const Text(
                    "  Terms of use",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: bh * 0.07),
          Container(
            color: Colors.black,
            height: th * 0.004,
            width: tw * 0.8,
          ),
          SizedBox(height: bh * 0.04),
          Column(
            children: [Text("Version")],
          )
        ],
      ),
    )));
  }
}
