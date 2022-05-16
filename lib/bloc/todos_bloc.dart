import 'dart:async';
// import '../model/thingstodo.dart';
//import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_todo_app/model/todos_model.dart';
// import '../model/thingstodo.dart';
part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodoEvent, TodosState> {
  TodosBloc() : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<UpdateTodo>(_onUpdateTodo);
  }

  FutureOr<void> _onLoadTodos(event, Emitter<TodosState> emit) {
    emit(TodosLoaded(todos: event.todos));
  }

  FutureOr<void> _onAddTodo(event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoaded) {
      emit(TodosLoaded(
        todos: List.from(state.todos)..add(event.todo),
      ));
    }
  }

  FutureOr<void> _onDeleteTodo(event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> todos = (state.todos.where((todo) {
        return todo.id != event.todo.id;
      })).toList();

      emit(TodosLoaded(todos: todos));
    }
  }

  FutureOr<void> _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> todos = (state.todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      })).toList();

      emit(TodosLoaded(todos: todos));
    }
  }
  //   void _onUpdateTodo(
  //   UpdateTodo event,
  //   Emitter<TodosState> emit,
  // ) {
  //   final state = this.state;
  //   if (state is TodosLoaded) {
  //     List<Todo> todos = (state.todos.map((todo) {
  //       return todo.id == event.todo.id ? event.todo : todo;
  //     })).toList();

  //     emit(TodosLoaded(todos: todos));
  //   }
  //}
}
