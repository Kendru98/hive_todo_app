import 'package:equatable/equatable.dart';
import 'package:hive_todo_app/boxes.dart';

class Todo extends Equatable {
  final String name;
  final String createdDate;
  final bool setreminder; //= false;
  final DateTime endDate;
  final List<String> thingstodo;
  final double progress;
  bool? isCompleted;
  bool? isCancelled;

  Todo({
    required this.name,
    required this.createdDate,
    required this.setreminder,
    required this.endDate,
    required this.thingstodo,
    required this.progress,
    this.isCompleted,
    this.isCancelled,
  }) {
    isCompleted = isCompleted ?? false;
    isCancelled = isCancelled ?? false;
  }

  Todo copyWith({
    final String? name,
    final String? createdDate,
    final bool? setreminder, //= false;
    final DateTime? endDate,
    final List<String>? thingstodo,
    final double? progress,
    bool? isCompleted,
    bool? isCancelled,
  }) {
    return Todo(
      name: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  @override
  List<Object?> get props => [
        id,
        task,
        description,
        isCompleted,
        isCancelled,
      ];

  List<Todo> todos = Boxes.getToDos().values.toList();
  //ogarnij model todoes aby byl 1
//     ValueListenableBuilder<Box<ToDo>>(
//       valueListenable: Boxes.getToDos().listenable(),
//       builder: (context, box, _) {
//     static List<Todo> = box.values.toList().cast<ToDo>()
// },
// );
  //

}
