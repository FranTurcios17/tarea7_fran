import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tarea7_fran/types/task.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


late List <Task> taskList;
late StreamController<List<Task>> controller;
TextEditingController textController = TextEditingController();
@override
  void initState() {
    
    super.initState();
    taskList = [];
    controller = StreamController<List<Task>>();
    controller.add(taskList);
  }

@override
  void dispose() {
    controller.close();
    super.dispose();
  }

  void addTask(String des)
  {
      taskList.add(Task(des));
      controller.add(taskList);
  }

  void updateTask(int index, bool completed)
  {
    taskList[index].state = (completed) ? TaskStates.COMPLETED : TaskStates.INCOMPLETED;
    controller.add(taskList);
  }

  void deleteTask(int index)
  {
    taskList.removeAt(index);
    controller.add(taskList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tareas por hacer'),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(18),
          child: TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Tarea',
              border: OutlineInputBorder()
            ),
          ),),

            ElevatedButton(onPressed: ()
            {
              if(textController.text.isNotEmpty)
              {
                addTask(textController.text);
                textController.clear();
              }
            }, 
            child: const Text('Agregar Tarea')),

            Expanded(
              child: StreamBuilder(
                stream: controller.stream,
                builder: (context, snapshot) {
                  if(snapshot.hasError)
                  {
                    return const Center(
                      child: Text('ha ocurrido un error'),
                    );
                  }
                  if(!snapshot.hasData || snapshot.data!.isEmpty)
                  {
                    return const Center(
                      child: Text('todavia no hay tareas, agrega una!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          
                          leading:  CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(snapshot.data![index].descripcion),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: (snapshot.data![index].state == TaskStates.COMPLETED),
                                onChanged: (value) {
                                  updateTask(index, value!);
                                },
                              ),

                              //no pude ponerle una separacion, porque da errores

                              IconButton(onPressed: ()
                              {
                                deleteTask(index);
                              }, 
                              icon: const Icon(Icons.delete))
                            ],
                          ),
                        
                        ),
                      );
                    },
                  );
                } ,
              ))


        ],
      ),
    );
  }
}