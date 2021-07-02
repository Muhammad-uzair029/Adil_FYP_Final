import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBStudentManager {
  Database _datebase;

  Future openDB() async {
    if (_datebase == null) {
      _datebase = await openDatabase(join(await getDatabasesPath(), "fvrts.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE fvrt1 (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,productdescription TEXT,email TEXT,mobile TEXT,address TEXT,productName TEXT,productPrice TEXT,productID TEXT,image TEXT,HotelStaffID TEXT,time TEXT)");
      });
    }
  }

  Future<int> insertStudent(Student student) async {
    await openDB();
    return await _datebase.insert('fvrt1', student.toMap());
  }

  Future<List<Student>> getStudentList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _datebase.query('fvrt1');

    return List.generate(maps.length, (index) {
      return Student(
        id: maps[index]['id'],
        name: maps[index]['name'],
        productdescription: maps[index]['productdescription'],
        email: maps[index]['email'],
        mobile: maps[index]['mobile'],
        address: maps[index]['address'],
        productName: maps[index]['productName'],
        productPrice: maps[index]['productPrice'],
        productID: maps[index]['productID'],
        image: maps[index][' image'],
        HotelStaffID: maps[index]['HotelStaffID'],
        time: maps[index]['time'],
      );
    });
  }

  Future<int> updateStudent(Student student) async {
    await openDB();
    return await _datebase.update('fvrt1', student.toMap(),
        where: 'id=?', whereArgs: [student.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDB();
    await _datebase.delete("fvrt1", where: "id = ? ", whereArgs: [id]);
  }
}

class Student {
  int id;
  String name,
      productdescription,
      email,
      mobile,
      address,
      productName,
      productPrice,
      productID,
      image,
      HotelStaffID,
      time;

  Student({
    @required this.name,
    @required this.productdescription,
    @required this.email,
    @required this.mobile,
    @required this.productName,
    @required this.productPrice,
    @required this.productID,
    @required this.address,
    @required this.image,
    @required this.HotelStaffID,
    @required this.time,
    this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'productdescription': productdescription,
      'email': email,
      'mobile': mobile,
      'address': address,
      'productName': productName,
      'productPrice': productPrice,
      'productID': productID,
      'image': image,
      'HotelStaffID': HotelStaffID,
      'time': time
    };
  }
}
