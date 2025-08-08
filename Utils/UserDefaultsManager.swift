import Foundation

class UserDefaultsManager {
  private let tasksKey = "tasks"

  func saveTasks(_ tasks: [Task]) {
    if let encoded = try? JSONEncoder().encode(tasks) {
      UserDefaults.standard.set(encoded, forKey: tasksKey)
    }
  }

  func loadTasks() -> [Task] {
    guard let data = UserDefaults.standard.data(forKey: tasksKey),
      let tasks = try? JSONDecoder().decode([Task].self, from: data)
    else {
      return []
    }
    return tasks
  }
}
