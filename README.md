

---

# Music Library App
![Flutter](https://img.shields.io/badge/Flutter-App-blue?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-Programming-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State%20Management-BLoC-blueviolet)
![API](https://img.shields.io/badge/API-iTunes%20%7C%20LRCLIB-orange)
![Audio](https://img.shields.io/badge/Audio-Preview-green)
![Performance](https://img.shields.io/badge/Performance-50K%2B%20Tracks-success)
![Pagination](https://img.shields.io/badge/Feature-Infinite%20Scroll-blue)
![Offline](https://img.shields.io/badge/Support-Offline-red)
![Platform](https://img.shields.io/badge/Platform-Android-lightgrey?logo=android)

A Flutter music library app capable of rendering and interacting with 50,000+ tracks smoothly using paging and optimized state management.

---

## Demo Video

[![Watch Demo](https://img.youtube.com/vi/RDE7AvrUcGg/0.jpg)](https://youtube.com/shorts/RDE7AvrUcGg?feature=share)






## Features

* Loads 50,000+ tracks using paginated API calls
* Infinite scrolling (lazy loading, 50 items per request)
* A–Z grouped list with sticky headers
* Search without UI freezing (isolate-based filtering)
* Track details screen with full metadata
* Lyrics fetching using LRCLIB API
* 30-second audio preview playback
* Clear loading, error, and success states
* Explicit offline handling

Offline message shown:

```text
NO INTERNET CONNECTION
```

---

## APIs Used

* iTunes Search API (track list and details)
* LRCLIB API (lyrics)
* iTunes previewUrl (audio preview)

---

## Packages Used

```yaml
flutter_bloc
equatable
http
audioplayers
```

---

## Run the Project

```bash
flutter pub get
flutter run
```

Build release APK:

```bash
flutter build apk --split-per-abi
```

Recommended for modern Android devices:

```
app-arm64-v8a-release.apk
```

---

This project demonstrates scalable large-list rendering, smooth scrolling under load, and efficient state management in Flutter.
