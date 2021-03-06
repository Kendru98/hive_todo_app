import 'dart:async';
// import '../model/thingstodo.dart';
//import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_todo_app/api/todoservice.dart';
import '../model/thingstodo.dart';
part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoService _todoService;
  TodosBloc(this._todoService) : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<UpdateProgress>(_updateProgress);
  }

  FutureOr<void> _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) async {
    await _todoService.init();
    final todos = _todoService.getTodos();
    emit(TodosLoaded(todos));
  }

  FutureOr<void> _updateProgress(
      UpdateProgress event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoaded) {
      _todoService.updateProgress(event.progress, event.toDo);

      add(LoadTodos());
    }
  }

  FutureOr<void> _onAddTodo(AddTodo event, Emitter<TodosState> emit) {
    final currentState = state as TodosLoaded;
    _todoService.addTodo(event.todoName, event.tasklist);
    // add(LoadTodos(currentState.username));
    add(LoadTodos());
  }

  FutureOr<void> _onDeleteTodo(DeleteTodo event, Emitter<TodosState> emit) {
    final currentState = state as TodosLoaded;
    _todoService.removeTodo(event.todo);
    //  final  state = this.state;
    // final state = this.state;
    // if (state is TodosLoaded) {
    // List<ToDo> todos = (state.todos.where((todo) {
    //   return todo.id != event.todo.id;
    // })).toList();

    // emit(TodosLoaded(todos: todos));
    // }
    add(LoadTodos()); //odswiezy main view
  }

  FutureOr<void> _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit) {
    // final state = this.state;
    // if (state is TodosLoaded) {
    //   // List<ToDo> todos = (state.todos.map((todo) {
    //   //   return todo.id == event.todo.id ? event.todo : todo;
    //   // })).toList();

    //   // emit(TodosLoaded(todos: todos));
    // }
  }
}
