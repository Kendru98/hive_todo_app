import 'package:hive/hive.dart';

part 'thingstodo.g.dart';

@HiveType(typeId: 2)
class ToDo extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late DateTime createdDate;

  @HiveField(2)
  late bool setreminder = false;

  @HiveField(3)
  late DateTime endDate;

  @HiveField(4)
  late List<String> thingstodo;

  @HiveField(5)
  late double progress;

  @HiveField(6)
  late List<bool> isChecked;

  ToDo(this.name, this.createdDate, this.setreminder, this.endDate,
      this.isChecked, this.progress, this.thingstodo);
}
