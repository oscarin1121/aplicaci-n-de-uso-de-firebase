class AppRoutePaths {
  const AppRoutePaths._();

  static const login = '/login';
  static const tasks = '/tasks';
  static const newTask = '/tasks/new';
  static const taskDetail = '/tasks/:taskId';
  static const taskEdit = '/tasks/:taskId/edit';

  static String detail(String taskId) => '/tasks/$taskId';

  static String edit(String taskId) => '/tasks/$taskId/edit';
}
