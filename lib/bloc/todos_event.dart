part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();
}

class LoadTodos extends TodosEvent {
  LoadTodos();

  @override
  List<Object> get props => []; //[todos]
}

class AddTodo extends TodosEvent {
  final String todoName;
  final List<String> tasklist;

  const AddTodo(
    this.todoName,
    this.tasklist,
  );

  @override
  List<Object> get props => [todoName, tasklist];
}

class UpdateTodo extends TodosEvent {
  final ToDo todo;

  const UpdateTodo({
    required this.todo,
  });

  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodosEvent {
  final ToDo todo;

  const DeleteTodo({
    required this.todo,
  });

  @override
  List<Object> get props => [todo];
}
