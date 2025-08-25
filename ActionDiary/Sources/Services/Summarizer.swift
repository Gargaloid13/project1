import Foundation

enum Summarizer {
    static func summarize(day: Date, entries: [DiaryEntry]) -> DaySummary {
        let calendar = Calendar.current
        let texts = entries
            .filter { calendar.isDate($0.timestamp, inSameDayAs: day) }
            .map { $0.text.lowercased() }

        let total = texts.count
        let joined = texts.joined(separator: " ")

        let stopWords: Set<String> = [
            "и","в","во","на","но","что","как","к","по","за","от","до","через","из","с","со","я","мы","он","она","они","это","тот","эта","все","а","у","же","ли","да","нет","бы","были","был","была","буду","было","быть","еще","сегодня","сейчас"
        ]

        var frequency: [String: Int] = [:]
        let tokenizer = CharacterSet.alphanumerics.inverted
        joined
            .components(separatedBy: tokenizer)
            .filter { $0.count > 2 }
            .filter { stopWords.contains($0) == false }
            .forEach { token in frequency[token, default: 0] += 1 }

        let top = frequency
            .sorted { $0.value > $1.value }
            .prefix(7)
            .map { $0.key }

        let overview: String
        if total == 0 {
            overview = "Нет записей за этот день."
        } else {
            // Простая эвристика: берем первые 2-3 записи и конкатенируем ключевые слова
            let firstSnippets = entries
                .filter { calendar.isDate($0.timestamp, inSameDayAs: day) }
                .sorted(by: { $0.timestamp < $1.timestamp })
                .prefix(3)
                .map { $0.text }
            let headline = top.prefix(3).joined(separator: ", ")
            overview = [firstSnippets.joined(separator: ". "), headline]
                .filter { !$0.isEmpty }
                .joined(separator: " — ")
        }

        return DaySummary(date: day, totalEntries: total, keywords: Array(top), overview: overview)
    }
}

