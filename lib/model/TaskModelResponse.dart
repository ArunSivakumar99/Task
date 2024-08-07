import 'dart:convert';
/// taskName : "Task 1"
/// taskStatus : "New"
/// taskDescrition : "Task 1 dwn dfwndw"
/// taskDate : "29-09-1999"

TaskModelResponse taskModelResponseFromJson(String str) => TaskModelResponse.fromJson(json.decode(str));
String taskModelResponseToJson(TaskModelResponse data) => json.encode(data.toJson());
class TaskModelResponse {
  TaskModelResponse({
      String? taskName, 
      String? taskStatus, 
      String? taskDescrition, 
      String? taskDate,}){
    _taskName = taskName;
    _taskStatus = taskStatus;
    _taskDescrition = taskDescrition;
    _taskDate = taskDate;
}

  TaskModelResponse.fromJson(dynamic json) {
    _taskName = json['taskName'];
    _taskStatus = json['taskStatus'];
    _taskDescrition = json['taskDescrition'];
    _taskDate = json['taskDate'];
  }
  String? _taskName;
  String? _taskStatus;
  String? _taskDescrition;
  String? _taskDate;

  set taskName(String? value) {
    _taskName = value;
  }

  String? get taskName => _taskName;
  String? get taskStatus => _taskStatus;
  String? get taskDescrition => _taskDescrition;
  String? get taskDate => _taskDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskName'] = _taskName;
    map['taskStatus'] = _taskStatus;
    map['taskDescrition'] = _taskDescrition;
    map['taskDate'] = _taskDate;
    return map;
  }

  set taskStatus(String? value) {
    _taskStatus = value;
  }

  set taskDescrition(String? value) {
    _taskDescrition = value;
  }

  set taskDate(String? value) {
    _taskDate = value;
  }

  // static Map<String, dynamic> toMap(TaskModelResponse task) => {
  //   'taskName': task.taskName,
  //   'taskStatus': task.taskStatus,
  //   'taskDescrition': task.taskDescrition,
  //   'taskDate': task.taskDate
  // };
  //
  // static String encode(List<TaskModelResponse> task) => json.encode(
  //   task
  //       .map<Map<String, dynamic>>((task) => TaskModelResponse.toMap(task))
  //       .toList(),
  // );
  // static List<TaskModelResponse> decode(String task) =>
  //     (json.decode(task) as List<dynamic>)
  //         .map<TaskModelResponse>((item) => TaskModelResponse.fromJson(item))
  //         .toList();

}