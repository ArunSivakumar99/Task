import 'dart:convert';

import 'package:sample/model/TaskModelResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefs{
  String keyType = "key_Type";
   String keyTaskList = 'key_TaskList';
  //List<TaskModelResponse> taskList = List.map((item) => jsonEncode(item.toMap())).toList();

  static SharedPreferences? _sharedPrefs;

  init() async {
    if (_sharedPrefs == null ) {
      _sharedPrefs = await SharedPreferences.getInstance();
      //_sharedPrefs.reload();
    }
  }
  List<String> get taskListData=> _sharedPrefs?.getStringList('key_TaskList')??[];

  set taskListData(List<String> value){
    _sharedPrefs?.setStringList(keyTaskList, value);
  }
  load() async {
    if (keyType != null) {
      await _sharedPrefs!.reload();
      print("reload-data");
    }
  }

}
final sharedPrefs = SharedPrefs();
