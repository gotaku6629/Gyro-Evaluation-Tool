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
                Text('(ax, ay, az) = (${csv_data[0]}${csv_data[1]}${csv_data[2]}${csv_data[3]}${csv_data[4]} ${csv_data[5]}${csv_data[6]}${csv_data[7]}${csv_data[8]}${csv_data[9]} ${csv_data[10]}${csv_data[11]}${csv_data[12]}${csv_data[13]}${csv_data[14]}${csv_data[15]})'),
                Text('(wx, wy, wz) = (${csv_data[17]}${csv_data[18]}${csv_data[19]} ${csv_data[20]}${csv_data[21]}${csv_data[22]}${csv_data[23]} ${csv_data[24]}${csv_data[25]})'),
                Image.asset('assets/images/gyro_test.png'),
                Text(''),
                Text('RMSE = 0.871'),
              ],
            )
          ),
        ),
      ),
    );
  }
}
