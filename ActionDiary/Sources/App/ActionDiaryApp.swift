import SwiftUI

@main
struct ActionDiaryApp: App {
    @StateObject private var diaryStore = DiaryStore()
    @StateObject private var speechService = SpeechService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(diaryStore)
                .environmentObject(speechService)
        }
    }
}

