import 'package:isar/isar.dart';
part 'note_model.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;
  late DateTime lastModified;
}
