## ActionDiary (iOS)

Небольшое офлайн‑приложение‑дневник для iOS на SwiftUI:
- диктуйте действия голосом (SFSpeechRecognizer + AVAudioEngine)
- сохраняйте записи локально в JSON
- получайте дневной саммари: ключевые темы, количество записей и краткий обзор

### Требования
- Xcode 15+
- iOS 16.0+
- Homebrew (для установки XcodeGen) или создайте проект вручную в Xcode

### Быстрый старт (через XcodeGen)
1) Установите XcodeGen:
```bash
brew install xcodegen
```
2) Сгенерируйте Xcode-проект из `project.yml`:
```bash
cd ActionDiary
xcodegen generate
open ActionDiary.xcodeproj
```
3) Выберите схему ActionDiary и запустите на симуляторе/устройстве.

### Права и приватность
В `Info.plist` уже добавлены ключи:
- `NSSpeechRecognitionUsageDescription`
- `NSMicrophoneUsageDescription`

При первом запуске iOS спросит доступ к микрофону и распознаванию речи.

### Структура
- `project.yml` — конфигурация XcodeGen
- `Info.plist` — разрешения и настройки
- `Sources/` — код SwiftUI, модели, стор, распознавание речи и саммари

Основные экраны:
- Запись — старт/стоп диктовки, сохранение записи
- История — список записей по дням, удаление
- Саммари — сводка за выбранный день (ключевые темы и обзор)

### Редактирование бандл-идентификатора
По умолчанию: `com.yourorg.ActionDiary`. Поменяйте в `project.yml` при необходимости и пересоберите проект:
```bash
xcodegen generate
```

### Если без XcodeGen
Можно создать пустой iOS App (SwiftUI) проект в Xcode, затем перенести содержимое `Sources/` и `Info.plist` в ваш проект. Не забудьте добавить ключи приватности.

