import Foundation
import Combine

final class DiaryStore: ObservableObject {
    @Published private(set) var entries: [DiaryEntry] = []

    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(filename: String = "entries.json") {
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = folder.appendingPathComponent(filename)
        self.encoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
        self.decoder.dateDecodingStrategy = .iso8601
        self.encoder.dateEncodingStrategy = .iso8601
        load()
    }

    func add(text: String, at date: Date = Date()) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        entries.insert(DiaryEntry(timestamp: date, text: trimmed), at: 0)
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(id: UUID) {
        if let index = entries.firstIndex(where: { $0.id == id }) {
            entries.remove(at: index)
            save()
        }
    }

    func entries(for day: Date) -> [DiaryEntry] {
        let cal = Calendar.current
        return entries.filter { cal.isDate($0.timestamp, inSameDayAs: day) }
    }

    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try decoder.decode([DiaryEntry].self, from: data)
            self.entries = decoded.sorted(by: { $0.timestamp > $1.timestamp })
        } catch {
            // first run or failed to load — start empty
            self.entries = []
        }
    }

    private func save() {
        do {
            let data = try encoder.encode(entries)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Failed to save entries: \(error)")
        }
    }
}

