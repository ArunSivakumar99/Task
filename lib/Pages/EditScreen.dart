import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utils/AppColors.dart';
import '../Utils/ScreenSizeCalculator.dart';
import '../Utils/SharedPrefs.dart';
import '../Utils/UtilityMethods.dart';
import '../model/TaskModelResponse.dart';
import 'TaskList.dart';

class EditScreen extends StatefulWidget {
  List<TaskModelResponse> task;
  int index;
   EditScreen(this.task,this.index,{super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController taskNameController,taskDescriptionController,taskStatusController,taskDueDateController;
  TaskModelResponse taskModelResponse=TaskModelResponse();
  List<TaskModelResponse> taskData=[];
  @override
  void initState() {
    taskDescriptionController=TextEditingController();
    taskDueDateController=TextEditingController();
    taskNameController=TextEditingController();
    taskStatusController=TextEditingController();
    taskDueDateController.text=widget.task[widget.index].taskDate.toString();
    taskStatusController.text=widget.task[widget.index].taskStatus.toString();
    taskNameController.text=widget.task[widget.index].taskName.toString();
    taskDescriptionController.text=widget.task[widget.index].taskDescrition.toString();




    super.initState();

  }
  onBackPressed(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>TaskList()), (route)=>false);

  }
  @override
  Widget build(BuildContext context) {


    return       Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title:
          Text("Edit Task",
            style:Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 15.sp,
              color:Colors.black ,
              fontWeight: FontWeight.w500,

            ),),
          automaticallyImplyLeading: false,


        ),
        body:WillPopScope(
          onWillPop: (){
            return onBackPressed();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtility.displayHeight(context)*0.01,
                horizontal: ScreenUtility.displayWidth(context)*0.02
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textContainer(taskNameController, "Task name", "Name"),
                textContainer(taskStatusController, "Task status", "Status"),
                textContainer(taskDescriptionController, "Task Description", "Description"),
                textContainer(taskDueDateController, "Task Due Date", "Date"),
                SizedBox(
                  height: ScreenUtility.displayHeight(context)*0.01,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtility.displayWidth(context) * 0.01,
                      right: ScreenUtility.displayWidth(context) * 0.01),
                  child: ElevatedButton(

                      onPressed: () async{
                        setState(() {
                          taskModelResponse.taskStatus=taskStatusController.text;
                          taskModelResponse.taskDescrition=taskDescriptionController.text;
                          taskModelResponse.taskName=taskNameController.text;
                          taskModelResponse.taskDate=taskDueDateController.text;
                          taskData.add(taskModelResponse);
                        });
                         updateTask(taskData);
                        // await sharedPrefs.load();


                      },
                      style: ElevatedButton.styleFrom(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.sp),
                        ),
                        padding: const EdgeInsets.all(0.0),

                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height:
                        ScreenUtility.displayHeight(context) * 0.055,
                        //width: ScreenUtility.displayWidth(context)*2,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.sp)),
                            color: Colors.red),
                        child: Text(
                            "Update",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500)),
                      )),
                )




              ],
            ),
          ),
        )
    );

  }
  Widget textContainer(TextEditingController controller,String title,String hinttext){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style:Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
            color:Colors.black ,
            fontWeight: FontWeight.w300,
          ),),
        SizedBox(
          height: ScreenUtility.displayHeight(context)*0.01,
        ),
        Container(
          alignment: Alignment.center,
          height: ScreenUtility.displayHeight(context) * 0.070,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
          ),
          child: TextFormField(
              controller: controller,
              //maxLength: 10,
              keyboardType: TextInputType.name,
              style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                  fillColor: AppColors.borderColor,
                  filled: true,
                  hintText: hinttext,
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp),
                      borderSide: BorderSide(
                          color: AppColors.backGroundColor,
                          width: 1.sp)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp),
                      borderSide: BorderSide(
                          color: AppColors.backGroundColor,
                          width: 1.sp)))),
        ),
        SizedBox(
          height: ScreenUtility.displayHeight(context)*0.015,
        ),
      ],
    );
  }
  Future<void> updateTask(List<TaskModelResponse> task) async {

    print(widget.index);
    task.addAll(await getList());
    task.removeAt(widget.index+1);

    //task.add(taskModelResponse);

    setState(() {
      print(task.length);
      List<String> dataList = task.map((task) => jsonEncode(task.toJson())).toList();
      sharedPrefs.taskListData=dataList;
      print("sgate ${sharedPrefs.taskListData}");



    });
    //await sharedPrefs.load();
    //Navigator.pop(context);
    UtilityMethods.showFlutterToast("Task updated");

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>TaskList()), (route)=>false);

  }


  Future<List<TaskModelResponse>> getList() async{
    List<String> dataList=sharedPrefs.taskListData;

    return dataList.map((item) => TaskModelResponse.fromJson(jsonDecode(item))).toList();

    //return[];
  }
}
