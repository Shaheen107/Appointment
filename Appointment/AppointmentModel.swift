import Foundation

struct Appointment: Identifiable, Codable {
    var id = UUID()
    var title: String
    var date: Date
    var location: String
    var notes: String
    var priority: Priority
    var reminder: Bool
    var bookedBy: String
    var contactNumber: String

    enum CodingKeys: String, CodingKey {
        case id, title, date, location, notes, priority, reminder, bookedBy, contactNumber
    }
}

enum Priority: String, CaseIterable, Identifiable, Codable {
    case low, medium, high
    
    var id: String { rawValue }
}
