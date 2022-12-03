import 'package:country_code_picker/country_code_picker.dart';
import 'package:dialpad/DBhelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class Update extends StatefulWidget {
  int id;
  String name;
  String number;
  String mesag;
  String title;
  String imges;
  String timme;

  Update(this.imges, this.id, this.name, this.number, this.mesag, this.title,
      this.timme,
      {super.key}); // const Update({Key? key}) : super(key: key);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  Database? dbb;

  String? choose;
  DateTime dd = DateTime.now();
  TimeOfDay tt = TimeOfDay.now();

  time(BuildContext context) async {
    TimeOfDay? timePick =
        await showTimePicker(context: context, initialTime: tt);
    if (timePick != null && timePick != tt) {
      setState(() {
        tt = timePick;
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
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getdata();
  }

  // getdata() {
  //   Dbhelper().Getdatabs().then((value) {
  //     setState(() {
  //       dbb = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController title = TextEditingController();
    TextEditingController number = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController msg = TextEditingController();
    double th=MediaQuery.of(context).size.height;
    double tw=MediaQuery.of(context).size.width;
    double sth=MediaQuery.of(context).padding.top;
    double nvh=MediaQuery.of(context).padding.bottom;
    double aph=kToolbarHeight;
    double bh=th-sth-aph-nvh;
    return Scaffold(
      appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  if (choose == "Whatsapp") {
                    int id = widget.id;
                    String titl = title.text;
                    title.text = widget.title;
                    String nm = name.text;
                    name.text = widget.name;
                    String nmr = number.text;
                    number.text = widget.number;
                    String msgg = msg.text;
                    msg.text = widget.mesag;
                    String img = widget.imges;
                    String iim = "images/whatsapp.png";
                    img = iim;
                    String tyme =
                        "${tt.hour.toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')}  ${tt.period.name}  "
                        "${dd.day.toString().padLeft(2, '0')}-${dd.month.toString().padLeft(2, '0')}-${dd.year}";

                    if (kDebugMode) {
                      print("updtetimeshow==$tyme");
                    }

                    // Dbhelper()
                    //     .updatedata(id, titl, nm, nmr, msgg, img, tyme, dbb!)
                    //     .then((value) {
                    //   Navigator.pop(context);
                    // });
                  } else if (choose == "message") {
                    int id = widget.id;
                    String titl = title.text;
                    title.text = widget.title;
                    String nm = name.text;
                    name.text = widget.name;
                    String nmr = number.text;
                    number.text = widget.number;
                    String msgg = msg.text;
                    msg.text = widget.mesag;
                    String img = widget.imges;
                    String iim = "images/message.jpg";
                    img = iim;
                    String tyme =
                        "${tt.hour.toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')}  ${tt.period.name}  "
                        "${dd.day.toString().padLeft(2, '0')}-${dd.month.toString().padLeft(2, '0')}-${dd.year}";

                    // Dbhelper()
                    //     .updatedata(id, titl, nm, nmr, msgg, img, tyme, dbb!)
                    //     .then((value) {
                    //   Navigator.pop(context);
                    // });
                  } else if (number.text.isEmpty ||
                      title.text.isEmpty ||
                      name.text.isEmpty ||
                      msg.text.isEmpty ||
                      choose == '') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Select WhatsApp or Message")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Wrong Entry")));
                  }
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: bh*0.03,
                      color: Colors.black),
                ))
          ],
          centerTitle: true,
          title: const Text(
            "Edit Schedule",
            style: TextStyle(color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: bh*0.1,
                child: TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                      hintText: widget.title,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: bh * 0.01,
              ),
              Container(
                height: bh * 0.32,width: tw*1,
                color: Colors.black12,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: "Whatsapp",
                          groupValue: choose,
                          onChanged: (value) {
                            setState(() {
                              choose = value.toString();
                            });
                          },
                        ),
                        Text("WhatsApp",style: TextStyle(fontSize: bh*0.03),),
                        SizedBox(
                          width: tw * 0.15,
                        ),
                        Radio(
                          value: "message",
                          groupValue: choose,
                          onChanged: (value) {
                            setState(() {
                              choose = value.toString();
                            });
                          },
                        ),
                         Text("Text Message",style: TextStyle(fontSize: bh*0.03))
                      ],
                    ),
                    Container(
                      color: Colors.black,
                      height: bh * 0.002,
                      margin: EdgeInsets.only(left: tw*0.01, right: tw*0.01),
                    ),
                    SizedBox(height: bh * 0.02),
                    Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (e) => print(e.toLongString()),
                          initialSelection: 'IN',
                          favorite: const ['+91', 'IN'],
                        ),
                        SizedBox(
                          height: bh * 0.07,
                          width: tw * 0.46,
                          child: TextFormField(style: TextStyle(fontSize: bh*0.035),
                            controller: name,
                            decoration: InputDecoration(
                                hintText: widget.name,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
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
                      margin: EdgeInsets.only(left: tw*0.01),
                      height: bh * 0.07,
                      width: tw * 0.47,
                      child: TextFormField(
                        controller: number,
                        decoration: InputDecoration(
                            hintText: widget.number,
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
                height: bh * 0.22,
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
                          style: TextStyle(fontSize: bh*0.03),
                        ),
                        SizedBox(
                          width: tw * 0.37,
                        ),
                        Container(
                          height: bh * 0.04,
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
                                "${dd.day.toString().padLeft(2, '0')}-${dd.month.toString().padLeft(2, '0')}-${dd.year}",style: TextStyle(fontSize: bh*0.027),),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: bh * 0.002,
                      width: tw * 0.8,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.watch_later)),
                        const Text(
                          "Time",
                          style: TextStyle(),
                        ),
                        SizedBox(
                          width: tw * 0.4,
                        ),
                        Container(
                          height: bh * 0.04,
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
                                "${tt.hour.toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')} ${tt.period.name}",style: TextStyle(fontSize: bh*0.03),),
                            // child: Text(
                            //     "${tt.hour.bitLength.toString().padLeft(2, '0')}:${tt.minute.toString().padLeft(2, '0')} ${tt.period.name}"),
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
              Container(
                color: Colors.black12,
                child: Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.swipe)),
                         Text(
                          "Repeat",
                          style: TextStyle(fontSize: bh*0.03),
                        ),
                        SizedBox(
                          width: tw * 0.38,
                        ),
                        Container(
                          height: bh * 0.04,
                          width: tw * 0.25,
                          color: Colors.black12,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: bh * 0.01,
              ),
              Container(height: bh*0.15,width: tw*1,
                child: TextFormField(
                  controller: msg,
                  maxLines: 5,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  decoration: InputDecoration(
                      hintText: widget.mesag,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
