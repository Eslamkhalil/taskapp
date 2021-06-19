import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/shared/cubit/cubit.dart';

//TaskCubit.get(context);

Widget buildTaskItem(Map model ,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
   // if(direction is endToStart)
    TaskCubit.get(context).deleteFromDataBase(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          width: 90,
          height: 80,
          child: CircleAvatar(
            child: Text(
              model['time'],
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                model['date'],
                style: TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              TaskCubit.get(context).updateDateBase(status: 'Done', id: model['id']);
            },
            icon: Icon(
              Icons.done,
              color: Colors.green,
            )),
        SizedBox(
          width: 8,
        ),
        IconButton(
            onPressed: () {
              TaskCubit.get(context).updateDateBase(status: 'Archive', id: model['id']);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.grey,
            )),
      ],
    ),
  ),
);

Widget taskBuilder({@required List<Map> taskList}) => ConditionalBuilder(condition: taskList.length > 0,
  builder: (context) => ListView.separated(itemBuilder: (context , index){
    return buildTaskItem(taskList[index],context);
  }, separatorBuilder:(context , int) => SizedBox(height: 8.0,), itemCount: taskList.length),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu , size: 100.0,color: Colors.grey,),
        Text('Please add some Tasks', style: TextStyle(
            color: Colors.grey,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w600,
            fontSize: 18.0
        ),),
      ],
    ),
  ),
);

Widget defaultFormField(
        {TextEditingController controller,
        String hint,
        Function onTap,
        IconData icon}) =>
    TextFormField(
      controller: controller,
      onTap: onTap,
      validator: (value) {
        if (value.isEmpty) {
          return '$hint must be provided';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.red,
        ),
        // contentPadding: EdgeInsets.symmetric(horizontal:16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        hintText: hint,
      ),
    );
