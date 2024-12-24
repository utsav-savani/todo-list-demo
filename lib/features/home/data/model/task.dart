import 'package:isar/isar.dart';

part 'task.g.dart'; 

@Collection()
class Task {
  Id id;
  late String docId;
  late String title;
  late String description;
  bool isSynced = false;
  bool isDeleted = false;


  Task({
    this.id = Isar.autoIncrement,
    required this.docId,
    required this.title,
    required this.description,
  });

  factory Task.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Task(
      title: data['title'],
      description: data['description'],
      docId: documentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
