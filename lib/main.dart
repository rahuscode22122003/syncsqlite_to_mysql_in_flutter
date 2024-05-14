import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncmysql/syncronize.dart';


import 'contactinfomodel.dart';
import 'controller.dart';
import 'databsehelper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteDatabaseHelper.instance.db;
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sync Sqflite to Mysql',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();

  late List list;
  bool loading = true;
  Future userList()async{
    list = await Controller().fetchData();
    setState(() {loading=false;});
    //print(list);
  }

  Future syncToMysql()async{
    await SyncronizationData().fetchAllInfo().then((userList)async{
      EasyLoading.show(status: "Don't close app. we are sync...");
      await SyncronizationData().saveToMysqlWith(userList);
      EasyLoading.showSuccess('Successfully save to mysql');
    });
  }


  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }




  @override
  void initState() {
    super.initState();
    userList();
    isInternet();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer.cancel();
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sync Sqflite to Mysql"),
        actions: [
          IconButton(icon: Icon(Icons.refresh_sharp), onPressed: ()async{
            await SyncronizationData.isInternet().then((connection){
              if (connection) {
                syncToMysql();
                print("Internet connection available");
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Internet")));
              }
            });
          })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: name,
              decoration: InputDecoration(hintText: 'Enter name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: gender,
              decoration: InputDecoration(hintText: 'Enter gender'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async{
                ContactinfoModel contactinfoModel = ContactinfoModel(userId: 1,name: name.text,email: email.text,gender: gender.text,createdAt: DateTime.now().toString(), id: 2);
                await Controller().addData(contactinfoModel).then((value){
                  if (value>0) {
                    print("Success");
                    userList();
                  }else{
                    print("failed");
                  }

                });
              },
              child: Text("Save"),
            ),
          ),
          loading ?Center(child: CircularProgressIndicator()):Expanded(
            child: ListView.builder(
              itemCount: list.length==null?0:list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list[index]['id'].toString()),
                      SizedBox( width: 5,),
                      Text(list[index]['name']),
                    ],),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(list[index]['email']),
                      Text(list[index]['gender']),
                    ],),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
