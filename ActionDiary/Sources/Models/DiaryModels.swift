import Foundation

struct DiaryEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let timestamp: Date
    var text: String

    init(id: UUID = UUID(), timestamp: Date = Date(), text: String) {
        self.id = id
        self.timestamp = timestamp
        self.text = text
    }
}

struct DaySummary: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let totalEntries: Int
    let keywords: [String]
    let overview: String

    init(id: UUID = UUID(), date: Date, totalEntries: Int, keywords: [String], overview: String) {
        self.id = id
        self.date = date
        self.totalEntries = totalEntries
        self.keywords = keywords
        self.overview = overview
    }
}

