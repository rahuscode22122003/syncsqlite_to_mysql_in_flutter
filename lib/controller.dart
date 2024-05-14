import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:http/http.dart' as http;

import 'contactinfomodel.dart';
import 'databsehelper.dart';

class Controller {
  final conn = SqfliteDatabaseHelper.instance;

  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else {
      print(
          "Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

  Future<int> addData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result = 0; // Initialize result with a default value
    try {
      result = await dbclient.insert(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<int> updateData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result = 0; // Initialize result with a default value
    try {
      result = await dbclient.update(
          SqfliteDatabaseHelper.contactinfoTable, contactinfoModel.toJson(),
          where: 'id=?', whereArgs: [contactinfoModel.id]);
    } catch (e) {
      print(e.toString());
    }
    return result;
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
