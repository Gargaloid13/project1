import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            RecordView()
                .tabItem {
                    Label("Запись", systemImage: "mic")
                }
            HistoryView()
                .tabItem {
                    Label("История", systemImage: "list.bullet")
                }
            SummaryView()
                .tabItem {
                    Label("Саммари", systemImage: "chart.bar")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(DiaryStore())
            .environmentObject(SpeechService())
    }
}

