import 'dart:async';

class BackgroundTaskService {
  static final BackgroundTaskService _instance =
      BackgroundTaskService._internal();
  final _taskQueue = StreamController<Function>();

  factory BackgroundTaskService() {
    return _instance;
  }

  BackgroundTaskService._internal() {
    _taskQueue.stream.listen((task) {
      task();
    });
  }

  void addTask(Function task) {
    _taskQueue.add(task);
  }
}
