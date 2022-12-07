// import 'dart:async';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBhelper {
  Future<Database> Getedatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbname.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'create table Dialpad (id integer primary key autoincrement, name Text, number Text, message Text, date Text)');
    });
    return database;
  }

  Future<void> insertdata(String nname, String nnumber, String messages,
      String datee, Database database) async {
    String insertqry =
        "insert into Dialpad (name,number,message,date) values('$nname','$nnumber','$messages','$datee')";
    int cnt = await database.rawInsert(insertqry);
    print(cnt);
  }

  Future<List<Map>> viewdata(Database database) async {
    String viewqry = "select * from Dialpad";
    List<Map> list = await database.rawQuery(viewqry);
    print("List Of Data: $list");
    return list;
  }

  Future<void> deletedata(Database deletdata, int deleteid) async {
    String delete = "delete from Dialpad where id = '${deleteid}'";
    int cntt = await deletdata.rawDelete(delete);
    print("Deleted $cntt");
  }
}

//TODO  Third Database

// class Dbbhelper {
//   Future<Database> Getdataabs() async {
//     var dataabasepath = await getDatabasesPath();
//     String pathh = join(dataabasepath, 'list.db');
//     //open database
//     Database database = await openDatabase(pathh, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute(
//           'create table List (id integer primary key autoincrement, names Text)');
//     });
//     return database;
//   }
//
//   Future<void> insert(String nm, Database dbs) async {
//     String qry = "insert into List(names) values('$nm')";
//     int cunt = await dbs.rawInsert(qry);
//     if (kDebugMode) {
//       print("Third Databasse==$cunt");
//     }
//   }
//
//   Future<List<Map>> viewdataa(Database database) async {
//     String viewqry = 'select * from List';
//     List<Map> list = await database.rawQuery(viewqry);
//     print('Third Database==$list');
//
//     return list;
//   }
//
//   Future<void> deletdataa(Database dbbb, int id) async {
//     String delete = "delete from List where id='${id}'";
//     int ccntt = await dbbb.rawDelete(delete);
//     print("third db Deleted==$ccntt");
//   }
//
//   Future<void> updat(int id, String nme, Database db) async {
//     String updat = "update List set names='$nme' where id='$id' ";
//     int updte = await db.rawUpdate(updat);
//     print("update third databs==$updte");
//   }
// }

//TODO second database

class Dbhelper {
  Future<Database> Getdatabs() async {
    // Get a location using getDatabasesPath
    var databasepath = await getDatabasesPath();
    String pathh = join(databasepath, 'dbnamee.db');

    //open database
    Database database = await openDatabase(pathh, version: 1,
        onCreate: (Database dbb, int version) async {
      await dbb.execute(
          'create table List (listid integer primary key autoincrement, names Text)');

      await dbb.execute(
          'create table Schedule (id integer primary key autoincrement, namew Text, numberw Text, messagew Text, title Text, imagew Text,datew Text, ListData integer, FOREIGN KEY(ListData) REFERENCES List(listid))');
    });
    return database;
  }

  Future<void> indata(String nmw, String numw, String mesg, String titles,
      String img, String det, String sl, Database databasee) async {
    print("hhhhhhhhhhh$sl");
    String inqry =
        "insert into Schedule(namew,numberw,messagew,title,imagew,datew,ListData) values('$nmw','$numw','$mesg','$titles','$img','$det','$sl')";
    int cntt = await databasee.rawInsert(inqry);
    if (kDebugMode) {
      print("2nd dbb==$cntt");
    }
  }

  Future<void> indataa(String list, Database database) async {
    String qry = "insert into List(names) values('$list')";
    int cunt = await database.rawInsert(qry);
    if (kDebugMode) {
      print("Third Databasse==$cunt");
    }
  }

  Future<List<Map>> viewdataa(Database database) async {
    String viewqry = 'select * from List';
    List<Map> list = await database.rawQuery(viewqry);
    print('Third Database==$list');

    return list;
  }

  Future<void> deletdataa(Database dbbb, int id) async {
    String delete = "delete from List where listid='${id}'";
    int ccntt = await dbbb.rawDelete(delete);
    print("third db Deleted==$ccntt");
  }

  Future<void> updat(int id, String nme, Database db) async {
    String updat = "update List set names='$nme' where listid='$id' ";
    int updte = await db.rawUpdate(updat);
    print("update third databs==$updte");
  }

  Future<List<Map>> viewdata(int lists, Database database) async {
    String viewqry = "select * from Schedule where ListData=$lists";
    // String viewqry = "select * from Schedule";
    // String viewqry = "SELECT * FROM List where names";
    List<Map> list = await database.rawQuery(viewqry);

    if (kDebugMode) {
      print("2ndlistUniqueData$list");
    }
    if (kDebugMode) {
      print("2ndlistUniqueData2ndlistUniqueData2ndlistUniqueData$lists");
    }

    return list;
  }

  Future<void> deletdata(Database database, int id) async {
    String delet = "delete from Schedule where id='$id'";
    int ccn = await database.rawDelete(delet);
    if (kDebugMode) {
      print("deleted2==$ccn");
    }
  }

  Future<void> updatedata(String titl, String nm, String nmr, String msgg,
      String imes, String times, String idd, int id, Database dbb) async {
    String updt =
        "update Schedule set namew='$nm',numberw='$nmr',messagew='$msgg',title='$titl',imagew='$imes' ,datew='$times' ,ListData='$idd' where id='$id'";
    int updtt = await dbb.rawUpdate(updt);
    print("Update2==$updtt");
  }
}
