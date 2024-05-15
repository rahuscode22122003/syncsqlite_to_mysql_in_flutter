import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:http/http.dart' as http;

import 'contactinfomodel.dart';
import 'databsehelper.dart'; // Corrected the filename

class Controller {
  final conn = SqfliteDatabaseHelper.instance;

  static Future<bool> isInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return await DataConnectionChecker().hasConnection;
    } else {
      return false;
    }
  }


  Future<int> addData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    try {
      return await dbclient.insert(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson());
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }


  Future<int> updateData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    try {
      return await dbclient.update(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson(),
          where: 'id = ?', whereArgs: [contactinfoModel.id]);
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<List<ContactinfoModel>> fetchData() async {
    var dbclient = await conn.db;
    List<ContactinfoModel> userList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient.query(
          SqfliteDatabaseHelper.contactinfoTable, orderBy: 'id DESC');
      for (var item in maps) {
        userList.add(ContactinfoModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;
  }

}
