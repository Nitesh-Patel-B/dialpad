//TODO recent

// import 'package:dialpad/main.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';
import 'DBhelper.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Recent extends StatefulWidget {
  const Recent({Key? key}) : super(key: key);

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  Database? db;
  List<Map> mm = [];

  List<Map> searchlist = [];

  bool issearch = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    speech = stt.SpeechToText();
    getdatabase();
  }

  Future<void> getdatabase() {
    DBhelper().Getedatabase().then((value) {
      if (mounted) {
        setState(() {
          db = value;
        });
      }
      DBhelper().viewdata(db!).then((listofmap) {
        if (mounted) {
          setState(() {
            mm = listofmap;
            searchlist = listofmap;
          });
        }
      });
    });
    return Future.value();
  }

  stt.SpeechToText speech = stt.SpeechToText();
  bool onlisn = false;
  String lisned = '';

  void lisn() async {
    if (!onlisn) {
      bool available = await speech.initialize(
        onStatus: (status) => print('listening: $status'),
        onError: (status) => print('error lisn: $status'),
      );
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
          // onResult: (result) => if(mounted) setState(() {
          //   lisned = result.recognizedWords;
          // }),
        );
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

  @override
  Widget build(BuildContext context) {
    TextEditingController search =
        TextEditingController(text: onlisn == false ? '' : lisned);

    double th = MediaQuery.of(context).size.height;
    double tw = MediaQuery.of(context).size.width;
    double sth = MediaQuery.of(context).padding.top;
    double nvh = MediaQuery.of(context).padding.bottom;
    double aph = kToolbarHeight;
    double bh = th - sth - aph - nvh;
    return mm.isNotEmpty
        ? Scaffold(
            key: GlobalKey(),
            backgroundColor: Colors.white60,
            body: RefreshIndicator(
                strokeWidth: 3,
                edgeOffset: 5,
                displacement: 50,
                color: Colors.green,
                backgroundColor: Colors.white70,
                onRefresh: getdatabase,
                child: Column(
                  children: [
                    SizedBox(
                      height: bh * 0.06,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: tw * 0.04),
                      child: Row(children: [
                        Text(
                          "Recents",
                          style: TextStyle(
                              fontSize: bh * 0.06, fontWeight: FontWeight.bold),
                        )
                      ]),
                    ),
                    Container(
                      height: bh * 0.12,
                      padding: const EdgeInsets.all(15),
                      // padding: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),

                      // TODO Search Bar

                      child: TextField(
                        enabled: true,
                        onTap: () {},
                        controller: search,
                        onChanged: (value) {
                          if (kDebugMode) {
                            print("vvvvvvvvvv$value");
                          }

                          if (mounted == false) {
                            setState(() {
                              if (value.isNotEmpty) {
                                searchlist = [];

                                for (int i = 0; i < mm.length; i++) {
                                  String num = mm[i]['number'];
                                  if (num.toLowerCase()
                                      .contains(value.toLowerCase())) {
                                    searchlist.add(mm[i]);
                                  }
                                }
                              } else {
                                searchlist = mm;
                              }
                            });
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: tw * 0.01, horizontal: bh * 0.1),
                            hintText: onlisn == false
                                ? "Search Here"
                                : 'Speak Now...',
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            suffixIcon: AvatarGlow(
                                animate: onlisn,
                                glowColor: Theme.of(context).primaryColor,
                                duration: const Duration(milliseconds: 2000),
                                repeatPauseDuration: const Duration(seconds: 1),
                                repeat: true,
                                endRadius: 40,
                                child: IconButton(
                                    onPressed: () => lisn(),
                                    icon: Icon(
                                        onlisn ? Icons.mic : Icons.mic_none))),
                            hintStyle:
                                const TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ),

                    //TODO END
                    Expanded(
                      child: SafeArea(
                          child: Center(
                              child: ListView.builder(
                        itemCount: issearch ? mm.length : searchlist.length,
                        itemBuilder: (context, index) {
                          Map map = issearch ? mm[index] : searchlist[index];
                          return Slidable(
                            endActionPane: ActionPane(
                              // dismissible: DismissiblePane(
                              //    onDismissed: ()=>remove(index)),
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  label: "Delete",
                                  foregroundColor: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                  backgroundColor: Colors.blue,
                                  icon: Icons.delete,
                                  onPressed: (context) {
                                    int id = mm[index]['id'];
                                    DBhelper().deletedata(db!, id);
                                  },
                                )
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                FlutterPhoneDirectCaller.callNumber(
                                    "${mm[index]['number']}");
                              },
                              child: Card(
                                color: Colors.green,
                                child: Dismissible(
                                  background: Container(
                                    color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                  fontSize: bh * 0.03),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Delete",
                                              style: TextStyle(
                                                  fontSize: bh * 0.03),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  key: ValueKey(mm[index]),
                                  movementDuration: const Duration(seconds: 2),
                                  onDismissed: (DismissDirection dire) {
                                    remove(index);
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.call),
                                    title: Text(
                                      "${map['number']}",
                                      style: TextStyle(
                                          fontSize: bh * 0.04,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    trailing: PopupMenuButton(
                                      icon: const Icon(Icons.delete_sweep),
                                      elevation: 200,
                                      color: Colors.green,
                                      iconSize: bh * 0.03,
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                              textStyle: const TextStyle(
                                                  color: Colors.redAccent),
                                              height: bh * 0.01,
                                              onTap: () {
                                                int id = mm[index]['id'];
                                                DBhelper().deletedata(db!, id);
                                              },
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                              ))
                                        ];
                                      },
                                    ),
                                    subtitle: Text("${mm[index]['date']}"),
                                    // subtitle: Text(
                                    //     "${dt.day}/${dt.month}/${dt.year}  ${td.hour}:${td.minute} ${td.period.name}    ${map['name']}    ${map['message']}",style: TextStyle(fontSize: bh*0.02),),

                                    // trailing: Text("${map['name']}"),
                                    // subtitle: Text("${map['message']}    ${map['name']}"),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ))),
                    ),
                  ],
                )),
          )
        : Scaffold(
            appBar: AppBar(
              title: Column(
                children: const [
                  Text(
                    "↓",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text("Refresh To Show Data"),
                ],
              ),
              centerTitle: true,
            ),
            body: RefreshIndicator(
                strokeWidth: 3,
                edgeOffset: 5,
                displacement: 50,
                color: Colors.green,
                backgroundColor: Colors.white70,
                onRefresh: getdatabase,
                child: SafeArea(
                    child: Center(
                        child: ListView(
                  children: [
                    // Image.asset('images/nodata.jpg'),
                    Center(
                        child: Container(
                      child: Lottie.asset('images/43191-no-data-error.json'),
                    ))
                  ],
                )))),
            // SafeArea(
            //     child: Center(
            //   child: Image.asset('images/nodata.jpg'),
          );
  }

  void remove(int index) {
    int id = mm[index]['id'];
    DBhelper().deletedata(db!, id);
  }
}
