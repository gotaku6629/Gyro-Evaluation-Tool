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
  List<String> data_list = [];

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
  // データをリスト構造に変換(各時刻ごとの値を入れる)
  trans_data(String csv_data){
    List<String> data_list = [];

    for (int i=0; i < 100; i++){
      String s_data = '';
      for (int j=0; j < 28; j++) {
        s_data = "${csv_data[28*i+j]}";
      }
      data_list.add(s_data);
    }
    return data_list;
  }

  @override
  Widget build(BuildContext context) {
    //loadAsset().then((t) => {print(t)});  // csvファイルのロード
    updateCsvData();
    //print(csv_data);
    data_list = trans_data(csv_data);

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
                Text('${data_list[i]}'),
                //Text('(ax, ay, az) = (${csv_data[0]}${csv_data[1]}${csv_data[2]}${csv_data[3]}${csv_data[4]} ${csv_data[5]}${csv_data[6]}${csv_data[7]}${csv_data[8]}${csv_data[9]} ${csv_data[10]}${csv_data[11]}${csv_data[12]}${csv_data[13]}${csv_data[14]}${csv_data[15]})'),
                //Text('(wx, wy, wz) = (${csv_data[17]}${csv_data[18]}${csv_data[19]} ${csv_data[20]}${csv_data[21]}${csv_data[22]}${csv_data[23]} ${csv_data[24]}${csv_data[25]})'),
                //Text('(wx, wy, wz) = (${csv_data[28]} ${csv_data[29]}${csv_data[30]}${csv_data[31]}${csv_data[32]} ${csv_data[33]}${csv_data[34]})'),
                Image.asset('assets/images/gyro_test.png'), //${csv_data[26]}${csv_data[27]}
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
