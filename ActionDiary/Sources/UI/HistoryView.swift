import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: DiaryStore

    var body: some View {
        List {
            ForEach(groupedByDay.keys.sorted(by: >), id: \.self) { day in
                Section(header: Text(dateFormatter.string(from: day))) {
                    ForEach(groupedByDay[day] ?? []) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.text)
                                .font(.body)
                            Text(timeFormatter.string(from: entry.timestamp))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                store.delete(id: entry.id)
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var groupedByDay: [Date: [DiaryEntry]] {
        let cal = Calendar.current
        return Dictionary(grouping: store.entries) { entry in
            cal.startOfDay(for: entry.timestamp)
        }
    }

    // Deletion handled via swipeActions per-entry
}

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    return df
}()

private let timeFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .none
    df.timeStyle = .short
    return df
}()

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(DiaryStore())
    }
}

