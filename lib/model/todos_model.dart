// import 'package:equatable/equatable.dart';

// import '../boxes.dart';

// class Todo extends Equatable {
//   final String name;
//   final String createdDate;
//   final bool setreminder; //= false;
//   final DateTime endDate;
//   final List<String> thingstodo;
//   final double progress;
//   bool? isCompleted;
//   bool? isCancelled;

//   Todo({
//     required this.name,
//     required this.createdDate,
//     required this.setreminder,
//     required this.endDate,
//     required this.thingstodo,
//     required this.progress,
//     this.isCompleted,
//     this.isCancelled,
//   }) {
//     isCompleted = isCompleted ?? false;
//     isCancelled = isCancelled ?? false;
//   }

//   Todo copyWith({
//     final String? name,
//     final String? createdDate,
//     final bool? setreminder, //= false;
//     final DateTime? endDate,
//     final List<String>? thingstodo,
//     final double? progress,
//     bool? isCompleted,
//     bool? isCancelled,
//   }) {
//     return Todo(
//       name: name ?? this.name,
//       endDate: endDate ?? this.endDate,
//       setreminder: setreminder ?? this.setreminder,
//       createdDate: createdDate ?? this.createdDate,
//       thingstodo: thingstodo ?? this.thingstodo,
//       progress: progress ?? this.progress,
//       isCompleted: isCompleted ?? this.isCompleted,
//       isCancelled: isCancelled ?? this.isCancelled,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         name,
//         endDate,
//         setreminder,
//         createdDate,
//         thingstodo,
//         isCompleted,
//         isCancelled,
//       ];

//   static List todos = Boxes.getToDos().values.cast().toList();

  // static List<Todo> todos = [
  //   Todo(
  //       name: 'name',
  //       createdDate: 'date',
  //       setreminder: true,
  //       endDate: DateTime.now(),
  //       thingstodo: ['thingstodo', 'as'],
  //       progress: 30.0)
  // ];
 
  //   Todo(
  //       name: 'name',
  //       createdDate: 'date',
  //       setreminder: true,
  //       endDate: DateTime.now(),
  //       thingstodo: ['thingstodo', 'as'],
  //       progress: 30.0)
  // ];

  //ogarnij model todoes aby byl 1
//     ValueListenableBuilder<Box<ToDo>>(
//       valueListenable: Boxes.getToDos().listenable(),
//       builder: (context, box, _) {
//     static List<Todo> = box.values.toList().cast<ToDo>()
// },
// );
  //

//}
