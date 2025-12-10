import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var body: String
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String = "", body: String = "") {
        self.id = UUID()
        self.title = title
        self.body = body
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(title: String, body: String) {
        self.title = title
        self.body = body
        self.updatedAt = Date()
    }
    
    var preview: String {
        body.isEmpty ? "No additional text" : body
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(updatedAt) {
            formatter.dateFormat = "h:mm a"
            return "Today, \(formatter.string(from: updatedAt))"
        } else if calendar.isDateInYesterday(updatedAt) {
            formatter.dateFormat = "h:mm a"
            return "Yesterday, \(formatter.string(from: updatedAt))"
        } else {
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: updatedAt)
        }
    }
}