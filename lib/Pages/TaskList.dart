import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/Pages/EditScreen.dart';
import 'package:sample/Utils/AppColors.dart';
import 'package:sample/Utils/Custompageroute.dart';
import 'package:sample/Utils/ScreenSizeCalculator.dart';
import 'package:sample/model/TaskModelResponse.dart';

import '../Utils/SharedPrefs.dart';
import '../Utils/UtilityMethods.dart';
import 'CreateTask.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskModelResponse> taskData=[];
  TaskModelResponse taskModel=TaskModelResponse();


  @override
  void initState() {
    // taskModel.taskDate="29-09-2024";
    // taskModel.taskName="Task 1";
    // taskModel.taskDescrition="Lorem ipsum dolor sit amet, consectetur adipiscing elit.Proin a dolor";
    // taskModel.taskStatus="New";
    //
    // taskData.add(taskModel);
    loadData();

    super.initState();
  }
  loadData() async{
    taskData.addAll(await  getList());
    setState(() {
      taskData;
    });

  }
  Future<List<TaskModelResponse>> getList() async{
    //await sharedPrefs.load();

    List<String> dataList=sharedPrefs.taskListData;

    return dataList.map((item) => TaskModelResponse.fromJson(jsonDecode(item))).toList();

    //return[];
  }



  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task",
        style:Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 15.sp,
          color:Colors.black ,
          fontWeight: FontWeight.w500,

        ),),


      ),
      body:       SizedBox(
        child:sharedPrefs.taskListData.isEmpty?Center(
          child:Text("Your task list is empty",
            style:Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 15.sp,
              color:Colors.red ,
              fontWeight: FontWeight.w500,

            ),),

        ): ListView.builder(
        shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount:taskData.length,
            itemBuilder: (BuildContext context,int index){
          return Container(
            //height: ScreenUtility.displayHeight(context)*0.15,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtility.displayHeight(context)*0.02,
                horizontal: ScreenUtility.displayWidth(context)*0.04),
            margin: EdgeInsets.symmetric(
              vertical: ScreenUtility.displayHeight(context)*0.01,
              horizontal: ScreenUtility.displayWidth(context)*0.02),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.backGroundColor
              ),
              borderRadius: BorderRadius.circular(5.sp),
              color: AppColors.borderColor

            ),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(text:TextSpan(
                            children: [
                              TextSpan(
                                  text: taskData[index].taskName,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 15.sp,
                                    color:Colors.black ,
                                    fontWeight: FontWeight.w500,)

                              ),
                              TextSpan(
                                  text: "(${taskData[index].taskStatus})",
                                  style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 14.sp,
                                    color:Colors.green ,
                                    fontWeight: FontWeight.w300,)

                              )
                            ]
                        )),

                        SizedBox(
                          height: ScreenUtility.displayHeight(context)*0.01,
                        ),
                      Text(taskData[index].taskDescrition.toString(),
                      textAlign: TextAlign.start,
                      style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      color:Colors.black ,
                      fontWeight: FontWeight.w300,

                      ),),
                        SizedBox(
                          height: ScreenUtility.displayHeight(context)*0.01,
                        ),
                        RichText(text:TextSpan(
                          children: [
                            TextSpan(
                              text: "Due date:",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 15.sp,
                              color:Colors.red ,
                              fontWeight: FontWeight.w400,)

                            ),
                            TextSpan(
                                text: taskData[index].taskDate.toString(),
                      style:Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      color:Colors.black ,
                      fontWeight: FontWeight.w300,)

                      )
                          ]
                        ))


                      ],
                    ),
                  ),

                ),
            Expanded(
              flex: 1,
              child: PopupMenuButton(
                itemBuilder:
                    (context) => [
                        PopupMenuItem(
                        child: Row(
                        children: [

                        Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: ScreenUtility.displayWidth(context) * 0.002),
                        child:
                        Text(
                        'Edit',
                        style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 13.sp),
                        ),
                        )
                        ],
                        ),
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_)=>EditScreen(taskData,index)));
                         // taskData.removeAt(index);


                        },
                ),
                PopupMenuItem(
                child:
                Row(
                children: [

                Padding(
                padding:
                EdgeInsets.symmetric(horizontal: ScreenUtility.displayWidth(context) * 0.002),
                child:
                Text(
                'Delete',
                style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13.sp),
                )),
               ] ),
                onTap: (){
                  setState(() {
                    taskData.removeAt(index);
                    List<String> dataList = taskData.map((task) => jsonEncode(task.toJson())).toList();
                    print(dataList);
                    sharedPrefs.taskListData=dataList;
                  });
                  UtilityMethods.showFlutterToast("Task Deleted");

                },),
                      PopupMenuItem(
                        child:
                        Row(
                            children: [

                              Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: ScreenUtility.displayWidth(context) * 0.002),
                                  child:
                                  Text(
                                    'Complete',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13.sp),
                                  )),
                            ] ),
                        onTap: (){
                          setState(() {
                            taskData[index].taskStatus="complete";
                            UtilityMethods.showFlutterToast("Task completed");


                          });
                        },)


                    ]
              ),
            ),
              ]
            ),
          );
        }),
      )
      ,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add
        ),
              onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(_)=>CreateTask()));
      }
      ),
    );
  }
}
