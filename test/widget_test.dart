import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_firebase_demo/features/auth/presentation/provider/auth_state.dart';
import 'package:todo_firebase_demo/features/home/data/model/task.dart';
import 'package:todo_firebase_demo/features/home/presentation/provider/task_state.dart';

class MockStateNotifier extends Mock implements AuthStateNotifier {}

class MockTasksStateNotifier extends Mock implements TaskNotifier {}

void main() {
  String email = 'testtodo@yopmail.com';
  String password = 'TestTodo1@234';
  final mockStateNotifier = MockStateNotifier();
  final taskNotifier = MockTasksStateNotifier();

  group('Group test', () {
    test('signup test', () async {
      print("signup trying");

      // call login method
      when(() => mockStateNotifier.register(
            email,
            password,
          )).thenAnswer((_) async {
        print("signup success");
      });

      await mockStateNotifier.register(email, password);
      verify(() => mockStateNotifier.register(email, password)).called(1);
    });
    test('login test', () async {
      print("Login trying");

      // call login method
      when(() => mockStateNotifier.login(email, password))
          .thenAnswer((_) async {
        print("Login success");
      });

      await mockStateNotifier.login(email, password);
      verify(() => mockStateNotifier.login(email, password)).called(1);
    });

    test('dashboard test', () async {
      when(() => mockStateNotifier.state)
          .thenReturn(AuthState.success('przhwY4r6AK4WDniokNL'));

      var userId = mockStateNotifier.state.userId ?? '';
      List<Task> mockTasks = [
        Task(description: "Task 1 desc", title: "Task 1", docId: ''),
        Task(description: "Task 2 desc", title: "Task 2", docId: ''),
      ];

      // call login method
      when(() => taskNotifier.addTask(
          task: mockTasks[0],
          isOnline: true,
          userId: userId)).thenAnswer((_) async {
        print("task 1 added success");
      });

      await taskNotifier.addTask(
          task: mockTasks[0], isOnline: true, userId: userId);

      when(() => taskNotifier.addTask(
          task: mockTasks[1],
          isOnline: true,
          userId: userId)).thenAnswer((_) async {
        print("task 2 added success");
      });

      await taskNotifier.addTask(
          task: mockTasks[1], isOnline: true, userId: userId);

      when(() => taskNotifier.tasks(
            isOnline: true,
            userId: userId,
          )).thenAnswer((invocation) => Future.value(mockTasks));

      var tasks = await taskNotifier.tasks(
        isOnline: true,
        userId: userId,
      );
      // Assert
      expect(tasks.length, 2);
      expect(tasks[0].title, 'Task 1');
      expect(tasks[1].title, 'Task 2');

      // call login method
      var updatedTask = Task(
          title: "Task 1 U",
          description: 'updated task 1 description',
          docId: '');
      when(() => taskNotifier.updateTask(
          task: updatedTask,
          isOnline: true,
          userId: userId)).thenAnswer((_) async {
        print("task 1 updates success");
      });

      await taskNotifier.updateTask(
          task: updatedTask, isOnline: true, userId: userId);

      mockTasks[0] = updatedTask;

      when(() => taskNotifier.tasks(
            isOnline: true,
            userId: userId,
          )).thenAnswer((invocation) => Future.value(mockTasks));

      var updatedTasks = await taskNotifier.tasks(
        isOnline: true,
        userId: userId,
      );
      // Assert
      expect(updatedTasks.length, 2);
      expect(updatedTasks[0].title, 'Task 1 U');
    });
  });
}
