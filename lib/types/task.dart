class Task{
  String descripcion;
  TaskStates state;

  Task(String des) : descripcion = des, state = TaskStates.INCOMPLETED;
  
}

enum TaskStates{
  COMPLETED, INCOMPLETED
}