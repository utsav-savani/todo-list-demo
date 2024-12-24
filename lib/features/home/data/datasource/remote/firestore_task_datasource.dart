import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';

class FirebaseTaskDatasource {
  Stream<List<Task>> fetchTasksStream(String userId) {
    return FirebaseFirestore.instance
        .collection('todo_demo')
        .doc(userId)
        .collection('tasks')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      // Convert each document into a Task object
      return snapshot.docs.map((doc) {
        return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<List<Task>> getAllTasks(String userId) async{
    var data =  await FirebaseFirestore.instance
        .collection('todo_demo')
        .doc(userId)
        .collection('tasks').get();
    return data.docs.map((doc) {
      return Task.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  Future<String> addTask(Task task, String userId) async {
    var res = await FirebaseFirestore.instance
        .collection('todo_demo')
        .doc(userId)
        .collection('tasks')
        .add(task.toMap());
    return res.id;
  }

  Future<void> updateTask(Task task, String userId) async {
    await FirebaseFirestore.instance
        .collection('todo_demo')
        .doc(userId)
        .collection('tasks')
        .doc(task.docId)
        .update(task.toMap());
  }

  Future<void> deleteTask(Task task, String userId) async {
    await FirebaseFirestore.instance
        .collection('todo_demo')
        .doc(userId)
        .collection('tasks')
        .doc(task.docId)
        .delete();
  }

  Future<Task?> getTaskById(String userId, String docId) async {
    var docSnapshot = await FirebaseFirestore.instance
        .collection('todo_demo')
        .doc(userId)
        .collection('tasks')
        .doc(docId)
        .get();

    if (docSnapshot.exists) {
      return Task.fromFirestore(docSnapshot.data()!, docSnapshot.id);
    }
    return null;
  }

}
