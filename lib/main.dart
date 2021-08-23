import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;  // ファイルを読み込む
import 'package:http/http.dart' as http;
import 'dart:async' show Future, StreamController;  // 非同期処理を行う
import 'dart:convert';  // httpレスポンスをJson形式に変更
import 'dart:math';

// http通信
Future<Album> fetchAlbum() async {
  // 1. 非同期でデータを読み込み
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  // 2. response=200だったらOK！
  if (response.statusCode == 200){
    return Album.fromJson(jsonDecode(response.body));
  } // 3. だめなら例外を投げる！
  else{
    throw Exception('Faild to load album');
  }
}
// body部分
class Album{
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json){
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String csv_data1 = "csv_data_1";
  String csv_data2 = "csv_data_2";
  int inc = 120;
  double rmse = 0.0;
  late List<List<dynamic>> data_list1;
  late List<List<dynamic>> data_list2;
  List<dynamic> display_data1 = [0, 0, 0, 0, 0, 0];
  List<dynamic> display_data2 = [0, 0, 0, 0, 0, 0];
  // Sreamを制御するコントローラーの定義
  //var controller = StreamController<String>();  // HTTP通信を行うデモ
  // Fetch the data
  //late Future<Album> futureAlbum;  // HTTP通信を行うデモ

  // csvデータをString型として受け取る (pubspec.yamlに登録したファイルの論理キーを指定)
  Future loadCsvAsset() async{
    String loadData = await rootBundle.loadString('assets/20200416_154101.csv');
    //csv_data = loadData;
    return loadData;
  }
  Future loadCsvAsset2() async{
    String loadData = await rootBundle.loadString('assets/20200416_155215.csv');
    //csv_data = loadData;
    return loadData;
  }
  // csvデータの更新
  void updateCsvData() {
    setState(() {
      loadCsvAsset().then((value){
        setState((){
          csv_data1 = value;
        });
      });
    });
    setState(() {
      loadCsvAsset2().then((value){
        setState((){
          csv_data2 = value;
        });
      });
    });
  }
  trans_data(String csv_data){
    var list = <List>[[], []];
    for (String line in csv_data.split("\r\n")){
      List<String> rows = line.split(',');
      list.add(rows);
    }
    return list;
  }

  // ボダンによるインクリメント
  _incrementCounter(List<List<dynamic>> list_data1, List<List<dynamic>> list_data2,){
    setState((){
      inc ++;
      display_data1 = list_data1[inc];
      display_data2 = list_data2[inc];
      rmse = sqrt(pow(double.parse(display_data1[0]) - double.parse(display_data2[0]), 2)
          + pow(double.parse(display_data1[1]) - double.parse(display_data2[1]), 2)
          + pow(double.parse(display_data1[2]) - double.parse(display_data2[2]), 2)
          + pow(double.parse(display_data1[3]) - double.parse(display_data2[3]), 2)
          + pow(double.parse(display_data1[4]) - double.parse(display_data2[4]), 2)
          + pow(double.parse(display_data1[5]) - double.parse(display_data2[5]), 2)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //loadAsset().then((t) => {print(t)});  // csvファイルのロード
    updateCsvData(); // 1. csvファイルをSringで読み込み
    //print(csv_data1);
    data_list1 = trans_data(csv_data1);  // 2. 2次元配列に格納
    data_list2 = trans_data(csv_data2);
    //print(data_list1);

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
                Text('Jyro Sensor', style: Theme.of(context).textTheme.display1,),
                Text('data1', style: Theme.of(context).textTheme.display1,),
                Text('$display_data1', style: Theme.of(context).textTheme.display1, ),
                Text('data2', style: Theme.of(context).textTheme.display1,),
                Text('$display_data2', style: Theme.of(context).textTheme.display1, ),
                Image.asset('assets/images/gyro_test.png'), //${csv_data[26]}${csv_data[27]}
                Text('$inc', style: Theme.of(context).textTheme.display1,),
                Text('RMSE', style: Theme.of(context).textTheme.display1,),
                Text('$rmse', style: Theme.of(context).textTheme.display1, ),
              ],
            )
          ),
        ),
        // ボタン操作に応じてrmseを増やす
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter(data_list1, data_list2),  // 関数へ
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
  /* HTTP通信をするデモプログラム
  @override
  void initState(){
    super.initState();
    futureAlbum = fetchAlbum();
  }

  print(fetchAlbum());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,  // fetchAlbum()の値が入る
            builder: (context, snapshot) {  // Futureの状態{loading, success, error}が入る
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
  */
}
