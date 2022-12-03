import 'package:dialpad/DBhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Listtupdt extends StatefulWidget {
  int id;
  String nm;
  Listtupdt(this.id, this.nm);

  @override
  State<Listtupdt> createState() => _ListtupdtState();
}

class _ListtupdtState extends State<Listtupdt> {
  Database? db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() {
    Dbhelper().Getdatabs().then((value) {
      setState(() {
        db = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nam = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Update List"),
        actions: [
          TextButton(
              onPressed: () {
                int id = widget.id;
                String nme = nam.text;
                nam.text = widget.nm;

                Dbhelper().updat(id, nme, db!);
                Navigator.pop(context);
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.green),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 40),
        child: TextField(
          controller: nam,
          decoration: InputDecoration(hintText: widget.nm,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }
}
