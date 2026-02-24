

---

# Music Library App

A Flutter music library app capable of rendering and interacting with 50,000+ tracks smoothly using paging and optimized state management.

---

## Demo Video

[Watch Demo Video](https://raw.githubusercontent.com/sourabhvamdevan/music_assignment/main/assets/demo/demo.mp4)






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
