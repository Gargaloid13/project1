import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var store: DiaryStore
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DatePicker("Дата", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)

            let dayEntries = store.entries(for: selectedDate)
            let summary = Summarizer.summarize(day: selectedDate, entries: dayEntries)

            GroupBox("Сводка") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Записей: \(summary.totalEntries)", systemImage: "number")
                        Spacer()
                    }
                    if summary.keywords.isEmpty == false {
                        WrapKeywordsView(keywords: summary.keywords)
                    }
                    Text(summary.overview)
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            if dayEntries.isEmpty == false {
                List(dayEntries) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.text)
                        Text(timeFormatter.string(from: entry.timestamp))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .listStyle(.plain)
            } else {
                Spacer()
            }
        }
        .padding()
    }
}

private struct WrapKeywordsView: View {
    let keywords: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Ключевые темы:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            FlexibleWrap(tags: keywords)
        }
    }
}

private struct FlexibleWrap: View {
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            var width: CGFloat = 0
            var height: CGFloat = 0

            return GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    ForEach(tags, id: \.self) { tag in
                        TagView(text: tag)
                            .padding([.horizontal, .vertical], 4)
                            .alignmentGuide(.leading, computeValue: { d in
                                if (abs(width - d.width) > geometry.size.width) {
                                    width = 0
                                    height -= d.height
                                }
                                let result = width
                                if tag == tags.last! { width = 0 } else { width -= d.width }
                                return result
                            })
                            .alignmentGuide(.top, computeValue: { _ in
                                let result = height
                                if tag == tags.last! { height = 0 }
                                return result
                            })
                    }
                }
            }
            .frame(height: 80)
        }
    }
}

private struct TagView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(6)
    }
}

private let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .none
    df.timeStyle = .short
    return df
}()

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
            .environmentObject(DiaryStore())
    }
}

