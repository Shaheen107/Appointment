import Foundation

struct DateFormatterUtil {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Adjust format as needed
        return formatter
    }()
}

extension Date {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        guard let date = DateFormatterUtil.dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        self = date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let dateString = DateFormatterUtil.dateFormatter.string(from: self)
        try container.encode(dateString)
    }
}
