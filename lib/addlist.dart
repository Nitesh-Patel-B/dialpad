import 'package:dialpad/DBhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Addlist extends StatefulWidget {
  const Addlist({Key? key}) : super(key: key);

  @override
  State<Addlist> createState() => _AddlistState();
}

class _AddlistState extends State<Addlist> {
  Database? db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    Dbhelper().Getdatabs().then((value) {
      setState(() {
        db = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("New List"),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                String nm = name.text;
                Dbhelper().indataa(nm, db!);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("List Added")));
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 20, color: Colors.green),
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 40, left: 15, right: 15),
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
