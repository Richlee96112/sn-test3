import Foundation

class TaskViewModel: ObservableObject {
  @Published private(set) var tasks: [Task] = []
  private let userDefaultsManager = UserDefaultsManager.shared

  init() {
    tasks = userDefaultsManager.loadTasks()
  }

  func addTask(_ title: String) {
    let task = Task(title: title)
    tasks.append(task)
    saveTasks()
  }

  func toggleTask(_ task: Task) {
    guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
    tasks[index] = Task(id: task.id, title: task.title, isCompleted: !task.isCompleted)
    saveTasks()
  }

  func deleteTask(_ task: Task) {
    tasks.removeAll { $0.id == task.id }
    saveTasks()
  }

  private func saveTasks() {
    userDefaultsManager.saveTasks(tasks)
  }
}

class TaskViewModel: ObservableObject {
  @Published var tasks: [Task] = []
  @Published var newTaskTitle: String = ""

  private let tasksKey = "tasks"

  init() {
    loadTasks()
  }

  func addTask() {
    guard !newTaskTitle.isEmpty else { return }
    let task = Task(title: newTaskTitle)
    tasks.append(task)
    newTaskTitle = ""
    saveTasks()
  }

  func toggleTask(_ task: Task) {
    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
      tasks[index].isCompleted.toggle()
      saveTasks()
    }
  }

  func deleteTask(_ task: Task) {
    tasks.removeAll { $0.id == task.id }
    saveTasks()
  }

  private func saveTasks() {
    if let encoded = try? JSONEncoder().encode(tasks) {
      UserDefaults.standard.set(encoded, forKey: tasksKey)
    }
  }

  private func loadTasks() {
    if let data = UserDefaults.standard.data(forKey: tasksKey),
      let decoded = try? JSONDecoder().decode([Task].self, from: data)
    {
      tasks = decoded
    }
  }
}

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
