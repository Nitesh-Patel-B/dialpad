import 'dart:ffi';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dialpad/DBhelper.dart';
import 'package:dialpad/addlist.dart';
import 'package:dialpad/main.dart';
// import 'package:dialpad/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

// import 'Secndnotify.dart';
import 'notification.dart';

class Event extends StatefulWidget {
  const Event({Key? key}) : super(key: key);

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  late final LocalNotificationService service;
  bool bl = false;
  Database? dbb;
  Database? dbbb;

  String? radio;
  String choose = "";
  String choosee = "images/message.jpg";

  DateTime dd = DateTime.now();

  TimeOfDay tt = TimeOfDay.now();

  // FlutterContactPicker cp = FlutterContactPicker();

  time(BuildContext context) async {
    TimeOfDay? timePick =
        await showTimePicker(context: context, initialTime: tt);
    if (timePick != null && timePick != tt) {
      setState(() {
        tt = timePick;

        if (kDebugMode) {
          print("timeeeeee$dd");
        }
      });
    }
  }

  datee(BuildContext context) async {
    DateTime? datePick = await showDatePicker(
        context: context,
        initialDate: dd,
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (datePick != null && datePick != dd) {
      setState(() {
        dd = datePick;
        if (kDebugMode) {
          print(dd.toString());
          print("dattttttte$dd");
        }
      });
    }
  }

  List<Map> mp = [];
  List<String> mylist = [];

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    // TODO: implement initState
    super.initState();
    per();
    getdata();
    // share();
    imge();
    getdataa();
  }

  imge() async {}

  // share() async {
  //   pre = await SharedPreferences.getInstance();
  //   // radio = pre!.getString("radio") ?? 'whatsapp';
  //   // print("rrrrrrrrrrr$radio");
  //   // radio == choose;
  //   setState(() {});
  // }
  Future<void> getdataa() async {
    Dbhelper().Getdatabs().then((value) {
      setState(() {
        dbbb = value;
      });
      Dbhelper().viewdataa(dbbb!).then((values) {
        setState(() {
          mp = values;

          for (int i = 0; i < mp.length; i++) {
            var data = mp[i].values.toString();
            var key = mp[i].keys.toString();
            var ts = mp[i].toString();


            setState(() {
              mylist.add(data);
            });

            if (kDebugMode) {
              print("keykeykeykey$key");
              print("datadatadatadata$data");
              print("mylistmylistnylist$mylist");
              print("tostringtostring$ts");

              // keykeykeykey[id, names]                 list
              // datadatadatadata(1, one)                String
              // mylistmylistnylist[{id: 1, names: one}] ListofMap
              // tostringtostring{id: 1, names: one}     Map

            }
          }
        });
      });
      return Future.value();
    });
  }

  Future<void> getdata() async {
    Dbhelper().Getdatabs().then((value) {
      setState(() {
        dbb = value;
      });
    });
  }

  per() async {
    var st = await Permission.contacts.status;
    if (st.isDenied) {
      await [
        Permission.contacts,
      ].request();
    } else if (st.isGranted) {}
  }

  // List<String> listitems = ["1", "2", "3", "4", "5", "6"];

  String? selectval;

  TextEditingController number = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController msg = TextEditingController();
  TextEditingController listt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double th = MediaQuery.of(context).size.height;
    double tw = MediaQuery.of(context).size.width;
    double sth = MediaQuery.of(context).padding.top;
    double nvh = MediaQuery.of(context).padding.bottom;
    double aph = kToolbarHeight;
    double bh = th - sth - aph - nvh;
    return Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text(
            "New Schedule",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (number.text.isEmpty ||
                    title.text.isEmpty ||
                    name.text.isEmpty ||
                    msg.text.isEmpty ||
                    choose == '') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please Enter All Deatils")));

                  if (kDebugMode) {
                    print("Blank");
                  }
                } else {
                  if (choose == "whatsapp") {
                    await service.showNotification(
                        id: 0, title: number.text, body: name.text);
                    if (kDebugMode) {
                      print("NotificationWhatsapp");
                    }

                    String img = "images/whatsapp.png";
                    String nmw = name.text;
                    String numw = number.text;
                    String mesg = msg.text;
                    String titles = title.text;
                    // String list = '';

                    String det =
                        "${tt.hour.remainder(12).toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')}  ${tt.period.name}  "
                        "\n${dd.day.toString().padLeft(2, '0')}-${dd.month.toString().padLeft(2, '0')}-${dd.year}";

                    Dbhelper().indata(
                        nmw, numw, mesg, titles, img, det, selectval!, dbb!);

                    if (kDebugMode) {
                      print("whatsapp cliked");
                    }
                    if (kDebugMode) {
                      print("radio$selectval");
                    }
                  } else if (choose == "Message") {
                    await service.showNotification(
                        id: 0, title: number.text, body: name.text);
                    if (kDebugMode) {
                      print("NotificationMessage");
                    }

                    String img = "images/message.jpg";
                    String nmw = name.text;
                    String numw = number.text;
                    String mesg = msg.text;
                    String titles = title.text;
                    // String list = listt.text;
                    String det =
                        "${tt.hour.remainder(12).toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')} ${tt.period.name}  "
                        "\n${dd.day.toString().padLeft(2, '0')}-${dd.month.toString().padLeft(2, '0')}-${dd.year}";

                    Dbhelper().indata(
                        nmw, numw, mesg, titles, img, det, selectval!, dbb!);
                    setState(() {});
                    if (kDebugMode) {
                      print("massage cliked");
                    }
                    if (kDebugMode) {
                      print("radio$selectval");
                    }
                  } else {
                    if (kDebugMode) {
                      print("No Radio click");
                    }
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                  left: tw * 0.02, right: tw * 0.02, top: bh * 0.01),
              child: Column(
                children: [
                  SizedBox(
                    child: TextFormField(
                      style: TextStyle(fontSize: bh * 0.03),
                      controller: title,
                      decoration: InputDecoration(
                          hintText: "Please Enter Schedule Title",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: bh * 0.01,
                  ),
                  Container(
                    height: bh * 0.3,
                    color: Colors.black12,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: "whatsapp",
                              groupValue: choose,
                              onChanged: (value) {
                                setState(() {
                                  choose = value.toString();

                                  if (kDebugMode) {
                                    print("whatsapp");
                                  }
                                });
                              },
                            ),
                            Text(
                              "WhatsApp",
                              style: TextStyle(fontSize: tw * 0.04),
                            ),
                            SizedBox(
                              width: tw * 0.2,
                            ),
                            Radio(
                              value: "Message",
                              groupValue: choose,
                              onChanged: (value) {
                                setState(() {
                                  choose = value.toString();
                                  if (kDebugMode) {
                                    print("Message");
                                  }
                                });
                              },
                            ),
                            Text(
                              "Text Message",
                              style: TextStyle(fontSize: tw * 0.04),
                            )
                          ],
                        ),
                        Container(
                          color: Colors.black,
                          height: bh * 0.002,
                          margin: EdgeInsets.only(
                              left: tw * 0.01, right: tw * 0.01),
                        ),
                        SizedBox(height: bh * 0.02),
                        Row(
                          children: [
                            SizedBox(
                              height: bh * 0.1,
                              width: tw * 0.3,
                              child: CountryCodePicker(
                                onChanged: (e) => print(e.toLongString()),
                                initialSelection: 'IN',
                                favorite: const ['+91', 'IN'],
                              ),
                            ),
                            SizedBox(
                              height: bh * 0.06,
                              width: tw * 0.5,
                              child: TextFormField(
                                style: TextStyle(fontSize: bh * 0.035),
                                controller: name,
                                decoration: InputDecoration(
                                    hintText: "Enter Name ",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            IconButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  var pr = await Permission.contacts.status;
                                  if (kDebugMode) {
                                    print(pr);
                                  }
                                },
                                icon: const Icon(Icons.person))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: tw * 0.14),
                          height: bh * 0.06,
                          width: tw * 0.5,
                          child: TextFormField(
                            style: TextStyle(fontSize: bh * 0.035),
                            controller: number,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Enter Number",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: bh * 0.01,
                  ),
                  Container(
                    height: bh * 0.213,
                    color: Colors.black12,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.calendar_today_sharp)),
                            Text(
                              "Date",
                              style: TextStyle(fontSize: tw * 0.045),
                            ),
                            SizedBox(
                              width: tw * 0.37,
                            ),
                            Container(
                              height: bh * 0.035,
                              width: tw * 0.3,
                              color: Colors.black12,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                onPressed: () {
                                  setState(() {
                                    datee(context);
                                  });
                                },
                                child: Text(
                                  "${dd.day.toString().padLeft(2, '0')}-${dd.month.toString().padLeft(2, '0')}-${dd.year}",
                                  style: TextStyle(fontSize: bh * 0.027),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: bh * 0.001,
                          width: tw * 0.8,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.watch_later)),
                            Text(
                              "Time",
                              style: TextStyle(fontSize: tw * 0.045),
                            ),
                            SizedBox(
                              width: tw * 0.37,
                            ),
                            Container(
                              height: bh * 0.035,
                              width: tw * 0.29,
                              color: Colors.black12,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                onPressed: () {
                                  setState(() {
                                    time(context);
                                  });
                                },
                                child: Text(
                                  "${tt.hour.remainder(12).toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')} ${tt.period.name}",
                                  style: TextStyle(fontSize: tw * 0.04),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: bh * 0.01,
                  ),
                  // Container(
                  //   height: bh * 0.07,
                  //   color: Colors.black12,
                  //   // child: Row(
                  //   //   children: [
                  //   //     IconButton(
                  //   //         onPressed: () {}, icon: const Icon(Icons.swipe)),
                  //   //     Text(
                  //   //       "Repeat",
                  //   //       style: TextStyle(fontSize: bh * 0.03),
                  //   //     ),
                  //   //     SizedBox(
                  //   //       width: tw * 0.38,
                  //   //     ),
                  //   //     // InkWell(
                  //   //     //   onTapUp: (details) {
                  //   //     //     if (kDebugMode) {
                  //   //     //       print("tappppped");
                  //   //     //     }
                  //   //     //   },
                  //   //     //   onTap: () {
                  //   //     //     showDialog(
                  //   //     //       context: context,
                  //   //     //       builder: (context) {
                  //   //     //         return AlertDialog(
                  //   //     //           alignment: Alignment.bottomLeft,
                  //   //     //           actions: [
                  //   //     //             Container(
                  //   //     //               height: bh * 0.6,
                  //   //     //               color: Colors.black12,
                  //   //     //               child: Row(
                  //   //     //                 mainAxisAlignment:
                  //   //     //                     MainAxisAlignment.spaceAround,
                  //   //     //                 children: [
                  //   //     //                   Column(
                  //   //     //                     children: [
                  //   //     //                       TextButton(
                  //   //     //                         onPressed: () {
                  //   //     //                           Navigator.pop(context);
                  //   //     //                         },
                  //   //     //                         child: Text("Never"),
                  //   //     //                       ),
                  //   //     //                       TextButton(
                  //   //     //                         onPressed: () {
                  //   //     //                           Navigator.pop(context);
                  //   //     //                         },
                  //   //     //                         child: Text("Daily"),
                  //   //     //                       ),
                  //   //     //                       TextButton(
                  //   //     //                         onPressed: () {
                  //   //     //                           Navigator.pop(context);
                  //   //     //                         },
                  //   //     //                         child: Text("Weekly"),
                  //   //     //                       ),
                  //   //     //                       TextButton(
                  //   //     //                         onPressed: () {
                  //   //     //                           Navigator.pop(context);
                  //   //     //                         },
                  //   //     //                         child: Text("Monthly"),
                  //   //     //                       ),
                  //   //     //                       TextButton(
                  //   //     //                         onPressed: () {
                  //   //     //                           Navigator.pop(context);
                  //   //     //                         },
                  //   //     //                         child: Text("Yearly"),
                  //   //     //                       ),
                  //   //     //                     ],
                  //   //     //                   ),
                  //   //     //                 ],
                  //   //     //               ),
                  //   //     //             )
                  //   //     //           ],
                  //   //     //         );
                  //   //     //       },
                  //   //     //     );
                  //   //     //   },
                  //   //     //   child: Container(
                  //   //     //       alignment: AlignmentDirectional.bottomEnd,
                  //   //     //       height: bh * 0.02,
                  //   //     //       width: tw * 0.24,
                  //   //     //       child: Text(
                  //   //     //         "Select",
                  //   //     //         style: TextStyle(color: Colors.black),
                  //   //     //       )),
                  //   //     // ),
                  //   //     // Text(
                  //   //     //   ">",
                  //   //     //   style: TextStyle(fontSize: bh * 0.05),
                  //   //     // )
                  //   //   ],
                  //   // ),
                  // ),
                  SizedBox(
                    height: bh * 0.01,
                  ),

                  Container(
                    height: bh * 0.1,
                    color: Colors.black12,
                    padding: EdgeInsets.only(left: tw * 0.022),
                    child: mp.isNotEmpty
                        ? Row(
                            children: [
                              Icon(Icons.list, size: 35),
                              Text(
                                "  List",
                                style: TextStyle(fontSize: bh * 0.03),
                              ),
                              SizedBox(width: tw * 0.35),

                              DropdownButton(
                                dropdownColor: Colors.grey,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20),
                                hint: Text("Select List"),
                                value: selectval,
                                onChanged: (value) {
                                  setState(() {
                                    selectval = value.toString();
                                    if (kDebugMode) {
                                      print("selected List==$selectval");
                                    }
                                  });

                                  print("outState=$selectval");
                                },
                                items: mylist.map((itemone) {
                                  return DropdownMenuItem(
                                      alignment: Alignment.center,

                                      // onTap: () {
                                      //   setState(() {
                                      //     print("this$selectval");
                                      //   });
                                      //
                                      // },

                                      value: itemone,
                                      child: Text(itemone));
                                }).toList(),
                              ),
                              // Container(
                              //   alignment: AlignmentDirectional.centerEnd,
                              //   width: tw * 0.25,
                              //   height: bh * 0.06,
                              //   child: MaterialButton(
                              //     child: Text(ii),
                              //     onPressed: () {
                              //       showDialog(
                              //         context: context,
                              //         builder: (context) {
                              //           return AlertDialog(
                              //             alignment: Alignment.bottomRight,
                              //             actions: [
                              //               Container(
                              //                 height: 200,
                              //                 width: 250,
                              //                 child: ListView.builder(
                              //                   itemCount: mp.length,
                              //                   itemBuilder: (context, index) {
                              //                     Map map = mp[index];
                              //
                              //                     return InkWell(onFocusChange: (value) {
                              //                       setState(() {
                              //                        print("object");
                              //                       });
                              //                     },
                              //                       // onTap: () {
                              //                       //
                              //                       //
                              //                       //
                              //                       //   build(context,index){
                              //                       //     String io=mp[index] as String;
                              //                       //     ii=io;
                              //                       //   };
                              //                       //   print("clik");
                              //                       //
                              //                       //   Navigator.pop(context);
                              //                       // },
                              //                       child: Card(
                              //                         child: ListTile(
                              //                             title: Text(
                              //                                 '${map['names']}')),
                              //                       ),
                              //                     );
                              //                   },
                              //                 ),
                              //               )
                              //               // Row(children: [
                              //               //   TextButton(
                              //               //       onPressed: () {
                              //               //
                              //               //         Navigator.pop(context);
                              //               //       },
                              //               //       child: Text("click")),
                              //               // ])
                              //             ],
                              //           );
                              //         },
                              //       );
                              //     },
                              //   ),
                              // )
                            ],
                          )
                        : Row(
                            children: [
                              Icon(Icons.list, size: 35),
                              Text(
                                "  List",
                                style: TextStyle(fontSize: bh * 0.03),
                              ),
                              SizedBox(width: tw * 0.35),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return Addlist();
                                      },
                                    ));
                                  },
                                  child: Text("Add list"))
                            ],
                          ),
                  ),
                  SizedBox(
                    height: bh * 0.01,
                  ),
                  SizedBox(
                    height: bh * 0.15,
                    child: TextFormField(
                      controller: msg,
                      maxLines: 5,
                      style: TextStyle(fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                          hintText: "Message Here",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);
  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Keypad())));
    }
  }
}
