import Foundation

class TaskViewModel: ObservableObject {
  @Published private(set) var tasks: [Task] = []
  private let userDefaultsManager = UserDefaultsManager()

  init() {
    tasks = userDefaultsManager.loadTasks()
  }

  func addTask(_ title: String) {
    guard !title.isEmpty else { return }
    let task = Task(title: title)
    tasks.append(task)
    userDefaultsManager.saveTasks(tasks)
  }

  func toggleTask(_ task: Task) {
    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks[index].isCompleted.toggle()
      userDefaultsManager.saveTasks(tasks)
    }
  }

  func deleteTask(_ task: Task) {
    tasks.removeAll { $0.id == task.id }
    userDefaultsManager.saveTasks(tasks)
  }
}
