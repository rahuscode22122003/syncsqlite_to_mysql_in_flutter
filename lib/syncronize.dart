import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'contactinfomodel.dart';
import 'package:http/http.dart' as http;

import 'databsehelper.dart';

class SyncronizationData {

  static Future<bool> isInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("Internet connection confirmed.");
        return true;
      } else {
        print('No internet connection.');
        return false;
      }
    } else {
      print("No internet connection.");
      return false;
    }
  }

  final conn = SqfliteDatabaseHelper.instance;

  Future<List<ContactinfoModel>> fetchAllInfo() async {
    final dbClient = await conn.db;
    List<ContactinfoModel> contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for (var item in maps) {
        contactList.add(ContactinfoModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future<void> saveToMysqlWith(List<ContactinfoModel> contactList) async {
    if (await isInternet()) {
      for (var i = 0; i < contactList.length; i++) {
        Map<String, dynamic> data = {
          "userId": contactList[i].userId.toString(), // Corrected parameter name
          "contact_id": contactList[i].id.toString(),
          "name": contactList[i].name,
          "email": contactList[i].email,
          "gender": contactList[i].gender,
          "createdAt": contactList[i].createdAt,
        };
        try {
          final response = await http.post(Uri.parse('http://192.168.1.19/syncmysqltosqflite/load_from_sqflite_contactinfo_table_save_or_update_to_mysql.php'), body: data);
          if (response.statusCode == 200) {
            print("Saving Data ");
          } else {
            print("Failed to save data: ${response.statusCode}");
          }
        } catch (e) {
          print("Error saving data: $e");
        }
      }
    } else {
      print("No internet connection. Cannot sync data to server.");
    }
  }


  Future<void> saveToMysql(List<Map<String, dynamic>> contactList) async {
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "userId": contactList[i]['userId'].toString(), // Corrected parameter name
        "contact_id": contactList[i]['id'].toString(),
        "name": contactList[i]['name'],
        "email": contactList[i]['email'],
        "gender": contactList[i]['gender'],
        "createdAt": contactList[i]['createdAt'],
      };
      try {
        final response = await http.post(Uri.parse('http://192.168.1.19/syncmysqltosqflite/load_from_sqflite_contactinfo_table_save_or_update_to_mysql.php'), body: data);
        if (response.statusCode == 200) {
          print("Saving Data ");
        } else {
          print("Failed to save data: ${response.statusCode}");
        }
      } catch (e) {
        print("Error saving data: $e");
      }
    }
  }
}
