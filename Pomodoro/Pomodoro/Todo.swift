import SwiftUI

struct Task: Identifiable, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool = false

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

struct Todo: View {
    @State private var tasks: [Task] = []
    @State private var newTaskTitle: String = ""
    
    private let tasksKey = "tasks"

    var body: some View {
            VStack {
                Text("Todo List")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .font(.title)
                    .bold()

                HStack {
                    TextField("Enter new task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTask) {
                        Text("Add")
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()

                List {
                    ForEach($tasks) { $task in
                        HStack {
                            Text(task.title)
                            Spacer()
                            Button(action: {
                                task.isCompleted.toggle()
                                saveTasks()
                            }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .blue : .gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteTask) // Swipe to delete
                }
            }
            .navigationTitle("Todo List")
            .onAppear(perform: loadTasks) // Load tasks when the view appears
        }
    

    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        tasks.append(Task(title: newTaskTitle))
        newTaskTitle = ""
        saveTasks()
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }
    
    private func loadTasks() {
        if let savedTasks = UserDefaults.standard.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
            tasks = decodedTasks
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }


}

struct TodoPreview: PreviewProvider {
    static var previews: some View {
        Todo()
    }
}
