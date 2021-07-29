import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;  // ファイルを読み込む
import 'dart:async' show Future;  // 非同期処理を行う

void main() => runApp(MyApp());


class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  String csv_data = "csv_data";
  double rmse = 0.0;

  void updateCsvData() {
    setState(() {
      loadCsvAsset().then((value){
        setState((){
          csv_data = value;
        });
      });
    });
  }
  // csvデータをString型として受け取る (pubspec.yamlに登録したファイルの論理キーを指定)
  Future loadCsvAsset() async{
    String loadData = await rootBundle.loadString('assets/20200416_155215.csv');
    //csv_data = loadData;
    return loadData;
  }

  @override
  Widget build(BuildContext context) {
    //loadAsset().then((t) => {print(t)});  // csvファイルのロード
    updateCsvData();
    //print(csv_data);

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gyro Evaluation'),
          actions: <Widget>[
            Icon(Icons.add),
            Icon(Icons.share),
          ],
        ),
        body: Container(
          //height: 200, width: 100,
          //color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Jyro Sensor :'),
                Text('${csv_data[0]}'),
                Image.asset('assets/images/gyro_test.png'),
              ],
            )
          ),
        ),
      ),
    );
  }
}
