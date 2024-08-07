import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/Pages/TaskList.dart';
import 'package:sample/Utils/AppColors.dart';
import 'package:sample/Utils/SharedPrefs.dart';
import 'package:sample/Utils/UtilityMethods.dart';
import 'package:sample/model/TaskModelResponse.dart';

import '../Utils/ScreenSizeCalculator.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  late TextEditingController taskNameController,taskDescriptionController,taskStatusController,taskDueDateController;
  TaskModelResponse taskModelResponse=TaskModelResponse();
  List<TaskModelResponse> taskData=[];
  @override
  void initState() {
    taskDescriptionController=TextEditingController();
    taskDueDateController=TextEditingController();
    taskNameController=TextEditingController();
    taskStatusController=TextEditingController();


    super.initState();

  }
  @override
  Widget build(BuildContext context) {


    return       Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title:
        Text("Create Task",
          style:Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 15.sp,
            color:Colors.black ,
            fontWeight: FontWeight.w500,

          ),),
        automaticallyImplyLeading: true,


      ),
      body:Padding(
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
                addTask(taskData);
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
                    "Save",
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

  Future<void> addTask(List<TaskModelResponse> task) async {
     task.addAll(await getList());

    setState(() {
       print(task.length);
      List<String> dataList = task.map((task) => jsonEncode(task.toJson())).toList();
      sharedPrefs.taskListData=dataList;
      print("sgate ${sharedPrefs.taskListData}");



    });
    //await sharedPrefs.load();
    //Navigator.pop(context);
     UtilityMethods.showFlutterToast("Task created");
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>TaskList()), (route)=>false);

   }
  Future<List<TaskModelResponse>> getList() async{
    List<String> dataList=sharedPrefs.taskListData;

    return dataList.map((item) => TaskModelResponse.fromJson(jsonDecode(item))).toList();

    //return[];
  }


}
