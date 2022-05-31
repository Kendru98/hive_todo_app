part of 'todos_bloc.dart';

abstract class TodosState extends Equatable {
  const TodosState();
}

class TodosLoading extends TodosState {
  @override
  List<Object> get props => [];
}

class TodosLoaded extends TodosState {
  final List<ToDo> todos;

  TodosLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

// class TodosError extends TodosState {}
