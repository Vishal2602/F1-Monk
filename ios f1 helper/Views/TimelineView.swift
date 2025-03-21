import SwiftUI

struct TimelineView: View {
    @StateObject private var viewModel = TimelineViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content
                HStack(spacing: 0) {
                    // Left sidebar with dates
                    VStack(spacing: 0) {
                        // Month and year
                        Text(viewModel.currentMonthYear)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                        
                        // Day headers and dates
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(viewModel.daysToShow, id: \.self) { date in
                                    DateSidebarItem(date: date, isToday: Calendar.current.isDateInToday(date))
                                        .frame(width: 65, height: 140)
                                }
                                
                                Spacer(minLength: 100)
                            }
                        }
                    }
                    .background(Color.black)
                    .frame(width: 65)
                    
                    // Right side with tasks
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(viewModel.daysToShow, id: \.self) { date in
                                VStack(alignment: .leading, spacing: 8) {
                                    let tasks = viewModel.tasksForDate(date)
                                    
                                    if tasks.isEmpty {
                                        EmptyTaskView()
                                            .frame(height: 140)
                                    } else {
                                        ForEach(tasks) { task in
                                            TaskItem(task: task)
                                                .padding(.bottom, 4)
                                        }
                                    }
                                }
                                .frame(minHeight: 140)
                                .padding(.vertical, 8)
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                
                // Floating action button for adding new tasks
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.showAddTask = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("F1 Timeline")
            .navigationBarItems(
                trailing: Button(action: {
                    viewModel.toggleFilter()
                }) {
                    Image(systemName: viewModel.showingAllTasks ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $viewModel.showAddTask) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }
}

// Date sidebar item - displays day of week and date
struct DateSidebarItem: View {
    let date: Date
    let isToday: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            // Day of week (MON, TUE, etc.)
            Text(dayOfWeek)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            // Date number
            Text(dayNumber)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(isToday ? Color.blue.opacity(0.3) : Color.clear)
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity)
    }
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

// Task item view
struct TaskItem: View {
    let task: TimelineTask
    @State private var isCompleted: Bool
    
    init(task: TimelineTask) {
        self.task = task
        self._isCompleted = State(initialValue: task.isCompleted)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Category color indicator
            Rectangle()
                .fill(categoryColor)
                .frame(width: 4)
                .cornerRadius(2)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    // Title and checkbox
                    HStack(alignment: .center, spacing: 10) {
                        // Checkbox
                        Button(action: {
                            isCompleted.toggle()
                            // In a real app, would update the task in the view model/database
                        }) {
                            Circle()
                                .strokeBorder(isCompleted ? Color.clear : Color.gray, lineWidth: 1.5)
                                .background(Circle().fill(isCompleted ? Color.green : Color.clear))
                                .frame(width: 22, height: 22)
                                .overlay(
                                    Group {
                                        if isCompleted {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Title
                        VStack(alignment: .leading, spacing: 3) {
                            Text(task.title)
                                .font(.headline)
                                .foregroundColor(isCompleted ? .gray : .white)
                                .strikethrough(isCompleted)
                                .lineLimit(2)
                            
                            if !task.location.isEmpty {
                                Text(task.location)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Priority dots (for high priority)
                    if task.priority == .high {
                        HStack(spacing: 4) {
                            ForEach(0..<3) { _ in
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 4, height: 4)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                
                // Time range
                if task.startTime != nil || task.endTime != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        
                        Text(timeRangeText)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 32)
                }
                
                // Description
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .padding(.leading, 32)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color(.systemBackground).opacity(0.15))
        .cornerRadius(8)
    }
    
    private var categoryColor: Color {
        switch task.category {
        case .document:
            return .blue
        case .deadline:
            return .red
        case .appointment:
            return .green
        case .application:
            return .orange
        case .other:
            return .purple
        }
    }
    
    private var timeRangeText: String {
        if let start = task.startTime, let end = task.endTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return "\(formatter.string(from: start)) → \(formatter.string(from: end))"
        } else if let start = task.startTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: start)
        } else if task.isAllDay {
            return "ALL DAY"
        }
        return ""
    }
}

// Empty task view
struct EmptyTaskView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("No tasks")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
        .background(Color(.systemBackground).opacity(0.1))
        .cornerRadius(8)
    }
}

// Add task view
struct AddTaskView: View {
    @ObservedObject var viewModel: TimelineViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var selectedDate = Date()
    @State private var startTime: Date? = nil
    @State private var endTime: Date? = nil
    @State private var isAllDay = false
    @State private var selectedCategory: TaskCategory = .document
    @State private var selectedPriority: TaskPriority = .normal
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    
                    TextField("Description", text: $description)
                    
                    TextField("Location", text: $location)
                }
                
                Section(header: Text("Date & Time")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    
                    Toggle("All Day", isOn: $isAllDay)
                    
                    if !isAllDay {
                        DatePicker("Start Time", selection: Binding(
                            get: { startTime ?? Date() },
                            set: { startTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                        
                        DatePicker("End Time", selection: Binding(
                            get: { endTime ?? (startTime?.addingTimeInterval(3600) ?? Date().addingTimeInterval(3600)) },
                            set: { endTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Document").tag(TaskCategory.document)
                        Text("Deadline").tag(TaskCategory.deadline)
                        Text("Appointment").tag(TaskCategory.appointment)
                        Text("Application").tag(TaskCategory.application)
                        Text("Other").tag(TaskCategory.other)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $selectedPriority) {
                        Text("Low").tag(TaskPriority.low)
                        Text("Normal").tag(TaskPriority.normal)
                        Text("High").tag(TaskPriority.high)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add F1 Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newTask = TimelineTask(
                        id: UUID().uuidString,
                        title: title,
                        description: description,
                        date: selectedDate,
                        startTime: isAllDay ? nil : startTime,
                        endTime: isAllDay ? nil : endTime,
                        isAllDay: isAllDay,
                        location: location,
                        category: selectedCategory,
                        priority: selectedPriority,
                        isCompleted: false
                    )
                    
                    viewModel.addTask(newTask)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

// Task data structures
enum TaskCategory: String, Codable {
    case document = "Document"
    case deadline = "Deadline"
    case appointment = "Appointment"
    case application = "Application"
    case other = "Other"
}

enum TaskPriority: String, Codable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"
}

struct TimelineTask: Identifiable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let startTime: Date?
    let endTime: Date?
    let isAllDay: Bool
    let location: String
    let category: TaskCategory
    let priority: TaskPriority
    var isCompleted: Bool
}

// ViewModel for the timeline
class TimelineViewModel: ObservableObject {
    @Published var tasks: [TimelineTask] = []
    @Published var showAddTask = false
    @Published var showingAllTasks = false
    
    private let calendar = Calendar.current
    
    init() {
        loadSampleTasks()
    }
    
    var daysToShow: [Date] {
        var days: [Date] = []
        let today = Date()
        
        for dayOffset in 0..<14 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                days.append(date)
            }
        }
        
        return days
    }
    
    var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    func tasksForDate(_ date: Date) -> [TimelineTask] {
        let filteredTasks = tasks.filter { task in
            calendar.isDate(task.date, inSameDayAs: date)
        }
        
        if showingAllTasks {
            return filteredTasks
        } else {
            return filteredTasks.filter { !$0.isCompleted }
        }
    }
    
    func addTask(_ task: TimelineTask) {
        tasks.append(task)
    }
    
    func toggleFilter() {
        showingAllTasks.toggle()
    }
    
    private func loadSampleTasks() {
        let today = Date()
        let calendar = Calendar.current
        
        // Create dates for the next few days
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: today)!
        let threeDaysFromNow = calendar.date(byAdding: .day, value: 3, to: today)!
        
        // Sample tasks for F1 visa timeline
        tasks = [
            TimelineTask(
                id: "1",
                title: "Submit I-20 Extension",
                description: "Contact DSO to begin I-20 extension process",
                date: today,
                startTime: nil,
                endTime: nil,
                isAllDay: true,
                location: "International Student Office",
                category: .document,
                priority: .high,
                isCompleted: false
            ),
            
            TimelineTask(
                id: "2",
                title: "OPT Application Deadline",
                description: "Complete and submit Form I-765 for OPT",
                date: tomorrow,
                startTime: nil,
                endTime: nil,
                isAllDay: true,
                location: "",
                category: .deadline,
                priority: .high,
                isCompleted: false
            ),
            
            TimelineTask(
                id: "3",
                title: "Appointment with DSO",
                description: "Review visa status and discuss OPT options",
                date: dayAfterTomorrow,
                startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: dayAfterTomorrow),
                endTime: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: dayAfterTomorrow),
                isAllDay: false,
                location: "Student Center Room 305",
                category: .appointment,
                priority: .normal,
                isCompleted: false
            ),
            
            TimelineTask(
                id: "4",
                title: "Verify SEVIS Record",
                description: "Ensure SEVIS information is accurate and up-to-date",
                date: threeDaysFromNow,
                startTime: nil,
                endTime: nil,
                isAllDay: false,
                location: "",
                category: .document,
                priority: .normal,
                isCompleted: true
            ),
            
            TimelineTask(
                id: "5",
                title: "Update Passport Copy",
                description: "Upload new passport copy to university portal",
                date: threeDaysFromNow,
                startTime: nil,
                endTime: nil,
                isAllDay: false,
                location: "",
                category: .document,
                priority: .low,
                isCompleted: false
            ),
            
            TimelineTask(
                id: "6",
                title: "Apply for SSN",
                description: "Visit Social Security office with job offer letter",
                date: calendar.date(byAdding: .day, value: 4, to: today)!,
                startTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 4, to: today)!),
                endTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: calendar.date(byAdding: .day, value: 4, to: today)!),
                isAllDay: false,
                location: "Social Security Administration Office",
                category: .application,
                priority: .high,
                isCompleted: false
            )
        ]
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
            .preferredColorScheme(.dark)
    }
} 