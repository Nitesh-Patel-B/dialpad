import 'package:avatar_glow/avatar_glow.dart';
import 'package:dialpad/DBhelper.dart';
import 'package:dialpad/NewSchedule.dart';
import 'package:dialpad/update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Eventlist extends StatefulWidget {
  const Eventlist({Key? key}) : super(key: key);

  @override
  State<Eventlist> createState() => _EventlistState();
}

class _EventlistState extends State<Eventlist> {
  Database? dbb;
  List<Map> mp = [];
  List<Map> searchlist = [];
  bool issearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    speech = stt.SpeechToText();
    // getdataa();
  }

  // getdataa() {
  //   Dbhelper().Getdatabs().then((value) {
  //     setState(() {
  //       dbb = value;
  //     });
  //     Dbhelper().viewdataa(dbb!).then((valuee) {
  //       setState(() {
  //         mp = valuee;
  //       });
  //     });
  //     return Future.value();
  //   });
  // }

//TODO
  getdata() {
    Dbhelper().Getdatabs().then((value) {
      setState(() {
        dbb = value;
      });
      Dbhelper().viewdata(dbb!).then((values) {
        setState(() {
          mp = values;
          searchlist = values;
        });
      });
      return Future.value();
    });
  }

//TODO
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
    // TextEditingController(text: onlisn == false ? '' : lisned);

    double th = MediaQuery.of(context).size.height;
    double tw = MediaQuery.of(context).size.width;
    double sth = MediaQuery.of(context).padding.top;
    double nvh = MediaQuery.of(context).padding.bottom;
    double aph = kToolbarHeight;
    double bh = th - sth - aph - nvh;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("List"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Event();
                  },
                ));
              },
              icon: Icon(
                Icons.add,
                color: Colors.green,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 80,
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    searchlist = [];
                    for (int i = 0; i < mp.length; i++) {
                      String namm = mp[i]['title'];
                      if (namm.toLowerCase().contains(value.toLowerCase())) {
                        searchlist.add(mp[i]);
                      }
                    }
                  } else {
                    searchlist = mp;
                  }
                });
              },
              decoration: InputDecoration(
                  suffixIcon: AvatarGlow(
                      animate: onlisn,
                      glowColor: Theme.of(context).primaryColor,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(seconds: 1),
                      repeat: true,
                      endRadius: 40,
                      child: IconButton(
                          onPressed: () => lisn(),
                          icon: Icon(onlisn ? Icons.mic : Icons.mic_none))),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),

          //TODO 2start
          //
          // SizedBox(
          //   height: bh * 0.8,
          //   child: ListView.builder(
          //     itemCount: mp.length,
          //     itemBuilder: (context, index) {
          //       Map map = mp[index];
          //       return Card(
          //         child: ListTile(title: Text("${map['names']['namew']}")),
          //       );
          //     },
          //   ),
          // )

          //TODO 2end

          // TODO Start

          SizedBox(
            height: bh * 0.8,
            // height: h * 0.391,
            child: ListView.builder(
              itemCount: issearch ? mp.length : searchlist.length,
              itemBuilder: (context, index) {
                Map map = issearch ? mp[index] : searchlist[index];

                return InkWell(
                  onTap: () {
                    int id = mp[index]['id'];
                    String name = mp[index]['namew'];
                    String number = mp[index]['numberw'];
                    String msgg = mp[index]['messagew'];
                    String title = mp[index]['title'];
                    String imes = mp[index]['imagew'];
                    String ttime = mp[index]['datew'];

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Update(
                              imes, id, name, number, msgg, title, ttime),
                        ));
                  },
                  onLongPress: () {},
                  child: Card(
                    child: ListTile(
                      leading: SizedBox(
                          height: bh * 0.07,
                          width: tw * 0.12,
                          child: Image.asset(mp[index]['imagew'])),
                      title: Text("${map['title']}",
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      subtitle: Container(
                        child: Text(
                          "${mp[index]['numberw']}(${mp[index]['namew']})${mp[index]['datew']}",
                          //trackartist
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      trailing: Container(
                        child: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 1) {
                              int id = mp[index]['id'];
                              String name = mp[index]['namew'];
                              String number = mp[index]['numberw'];
                              String msgg = mp[index]['messagew'];
                              String title = mp[index]['title'];
                              String imes = mp[index]['imagew'];
                              String ttime = mp[index]['datew'];

                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Update(imes, id, name, number, msgg,
                                      title, ttime);
                                },
                              ));
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  value: 0,
                                  textStyle:
                                      const TextStyle(color: Colors.redAccent),
                                  height: bh * 0.1,
                                  // height: h * 0.1,
                                  onTap: () {
                                    int id = mp[index]['id'];
                                    Dbhelper().deletdata(dbb!, id);
                                  },
                                  child: const Icon(Icons.delete)),
                              PopupMenuItem(
                                  onTap: () {},
                                  textStyle:
                                      const TextStyle(color: Colors.blue),
                                  // height: h * 0.1,
                                  height: bh * 0.1,
                                  value: 1,
                                  child: const Icon(Icons.update)),
                              PopupMenuItem(
                                  onTap: () {
                                    dbb!.delete('Schedule');
                                    if (kDebugMode) {
                                      print("All Deleted");
                                    }
                                  },
                                  child: const Text("DeleteAll"))
                            ];
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // TODO End
        ]),
      ),
    );
  }
}
