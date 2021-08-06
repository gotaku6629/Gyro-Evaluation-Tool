import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;  // ファイルを読み込む
import 'package:http/http.dart' as http;
import 'dart:async' show Future, StreamController;  // 非同期処理を行う
import 'dart:convert';  // httpレスポンスをJson形式に変更

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
  String csv_data = "csv_data";
  double rmse = 0.0;
  List<String> data_list = [];
  // Sreamを制御するコントローラーの定義
  var controller = StreamController<String>();
  // Fetch the data
  late Future<Album> futureAlbum;


  // csvデータをString型として受け取る (pubspec.yamlに登録したファイルの論理キーを指定)
  Future loadCsvAsset() async{
    String loadData = await rootBundle.loadString('assets/20200416_155215.csv');
    //csv_data = loadData;
    return loadData;
  }
  // csvデータの更新
  void updateCsvData() {
    setState(() {
      loadCsvAsset().then((value){
        setState((){
          csv_data = value;
        });
      });
    });
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
  void initState(){
    super.initState();
    futureAlbum = fetchAlbum();
  }

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
  /*
  @override
  Widget build(BuildContext context) {
    //loadAsset().then((t) => {print(t)});  // csvファイルのロード
    updateCsvData(); // これだと、csvファイルを一括でガッと読みとってる...
    //print(csv_data);
    data_list = trans_data(csv_data);
    print(fetchAlbum());

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
                //Text('${data_list[i]}'),
                Text('(ax, ay, az) = (${csv_data[0]}${csv_data[1]}${csv_data[2]}${csv_data[3]}${csv_data[4]} ${csv_data[5]}${csv_data[6]}${csv_data[7]}${csv_data[8]}${csv_data[9]} ${csv_data[10]}${csv_data[11]}${csv_data[12]}${csv_data[13]}${csv_data[14]}${csv_data[15]})'),
                Text('(wx, wy, wz) = (${csv_data[17]}${csv_data[18]}${csv_data[19]} ${csv_data[20]}${csv_data[21]}${csv_data[22]}${csv_data[23]} ${csv_data[24]}${csv_data[25]})'),
                //Text('(a, b, c) = (${csv_data[28]} ${csv_data[29]}${csv_data[30]}${csv_data[31]}${csv_data[32]} ${csv_data[33]}${csv_data[34]})'),
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
  */
}
