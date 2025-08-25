import SwiftUI

struct RecordView: View {
    @EnvironmentObject var speech: SpeechService
    @EnvironmentObject var store: DiaryStore

    @State private var noteText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Диктовка дневника")
                .font(.title2.bold())

            TextEditor(text: Binding(
                get: { speech.transcript.isEmpty ? noteText : speech.transcript },
                set: { noteText = $0 }
            ))
            .frame(minHeight: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )

            HStack(spacing: 12) {
                Button(action: toggleRecording) {
                    Label(speech.isRecording ? "Стоп" : "Записать", systemImage: speech.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.title3)
                }
                .buttonStyle(.borderedProminent)

                Button(action: saveEntry) {
                    Label("Сохранить", systemImage: "square.and.arrow.down")
                }
                .buttonStyle(.bordered)
                .disabled(currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Spacer()
        }
        .padding()
        .onDisappear { if speech.isRecording { speech.stop() } }
    }

    private var currentText: String {
        speech.transcript.isEmpty ? noteText : speech.transcript
    }

    private func toggleRecording() {
        if speech.isRecording {
            speech.stop()
        } else {
            do { try speech.start() } catch { print("Speech error: \(error)") }
        }
    }

    private func saveEntry() {
        let trimmed = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        store.add(text: trimmed)
        noteText = ""
        speech.transcript = ""
        if speech.isRecording { speech.stop() }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
            .environmentObject(DiaryStore())
            .environmentObject(SpeechService())
    }
}

