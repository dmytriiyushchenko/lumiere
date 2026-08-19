# Lumière

[![CI](https://github.com/dmytriiyushchenko/lumiere/actions/workflows/ci.yml/badge.svg)](https://github.com/dmytriiyushchenko/lumiere/actions/workflows/ci.yml)

An iOS app for people who spend forty minutes choosing a film and then go to bed.

Three questions — how much time you have, how much energy you have, what you want tonight — and Lumière gives you one film. Not a grid, not a carousel, not a top-100 list. One. Take it or ask for another.

| Time | Energy | Intent |
|---|---|---|
| ![Time](docs/screenshots/time.png) | ![Energy](docs/screenshots/energy.png) | ![Intent](docs/screenshots/intent.png) |

| Result | Detail | Watchlist |
|---|---|---|
| ![Result](docs/screenshots/result.png) | ![Detail](docs/screenshots/detail.png) | ![Watchlist](docs/screenshots/watchlist.png) |

## The idea

Streaming catalogues are built for browsing. Browsing is pleasant and endless, which is exactly the problem — the more options you see, the harder the decision gets, and the evening is over before the film starts.

Lumière removes the catalogue. It asks three short questions, then commits to a single recommendation. Everything you save or skip is remembered, so the same blockbuster never comes back a second time.

## Design

Hand-drawn marker aesthetic instead of the dark glossy grid every film app uses: rough ink borders, Permanent Marker and Patrick Hand typefaces, a warm paper palette, and a red-crowned crane as the mascot.

The borders are not images. They are a custom `Shape` that draws slightly wobbly rectangles using a seeded random generator, so every element gets its own imperfection and keeps the same one between launches.

## Architecture

MVVM with `@Observable` view models. Views stay declarative and own no networking; view models own state and talk to an injected API client; SwiftData holds anything that has to survive a restart.

```
App            LumiereApp → RootView (splash, then a two-tab shell)

Networking     APIClient (protocol) → TMDBClient
               Endpoint + static factories: discover, movie, videos
               NetworkError (LocalizedError), Secrets

Models         Movie, MovieResponse, Video, VideoResponse
               Runtime, Energy, Intent, MoodProfile, TMDBGenre, LoadingState
Persistence    SavedMovie, SeenMovie  (SwiftData @Model)

View models    SuggestionViewModel, DetailViewModel  (@MainActor @Observable)

Features       Picker      TimeStepView → EnergyStepView → IntentStepView
               Result      ResultView
               Detail      DetailView
               Watchlist   WatchlistView

Design system  Theme (palette and spacing), OptionButton, StarRating,
               WizardHeader, RoughRectangle
```

The wizard is coordinated by `PickerView` through a `NavigationPath`. Each step is a passive view: it reports the chosen value upwards through a callback and knows nothing about what comes next.

## Built with

- Swift 6, SwiftUI, SwiftData
- async/await with `URLSession`, `Codable`
- TMDB API — discover, movie details, trailers
- [Kingfisher](https://github.com/onevcat/Kingfisher) for poster loading and caching
- [YouTubePlayerKit](https://github.com/SvenTiigi/YouTubePlayerKit) for in-app trailers
- Swift Testing for decoding and mood-mapping tests

## Decisions worth explaining

**Mood is a matrix, not a genre picker.** An earlier version asked for a genre, which turned out to be the same browsing problem in a smaller box — people do not know their genre, they know their state. Energy and intent give nine combinations, and `MoodProfile` maps each to its own include and exclude lists. Within one energy level the three intents deliberately share no genres: popular films carry several genre tags, so any overlap makes two opposite moods return the same blockbusters.

**The API client is a protocol.** `TMDBClient` is one implementation; view models depend on `APIClient` and receive it through their initialiser. A mock plugs into the same socket, which is what makes the view models testable at all.

**Every TMDB URL is built by an `Endpoint` factory.** Query strings used to be assembled by hand in three different files, with force-unwrapped `URL(string:)` at the end of each. Now the knowledge about someone else's API lives in one type, `URLComponents` does the escaping, and `TMDBClient` unwraps the optional once and throws `NetworkError.invalidURL` instead of crashing.

**Pagination loads early, not late.** The pool of films is fetched a page at a time, and the next page starts loading three cards before the end, so "another one" never waits on the network. A boolean guard stops a fast tapper from firing two identical requests while the first is still in flight.

**One model, two endpoints.** `/discover` returns films without a runtime; `/movie/{id}` includes it. `Movie.runtime` is therefore optional — making it non-optional would break decoding of every discover response, and the detail screen simply omits the runtime when it is missing.

**Missing data is expected, not exceptional.** TMDB sends `"release_date": ""` as readily as it omits the key, and an empty string decodes perfectly well before painting a blank line under the title. The model treats both as absent.

**Trailers play inside the app.** A raw `WKWebView` embed fails on YouTube with errors 152 and 153, because the web view strips the referer and third-party cookies the player expects. Rather than fight that, the app uses a maintained library and keeps a plain link to YouTube as a fallback for videos whose owners disable embedding.

**The view model never touches the database.** Saving or skipping a film writes its id to a SwiftData store. The view reads that store and hands the list of ids to the view model, which filters every fetched page against it. The view model receives what it needs instead of reaching for it.

**A failed store falls back to memory instead of crashing.** If the SwiftData container cannot be opened on disk, the app opens an in-memory one and runs for the session — the watchlist is lost, the evening is not. `fatalError` is reserved for the case where the schema itself is invalid, which fails on the developer's machine long before a user sees it.

## Requirements

- iOS 18.6+
- Xcode 26
- A free TMDB API read access token

## Running it

The TMDB token is not in the repository. To build:

1. Create `Secrets.xcconfig` in the project root:
   ```
   TMDB_TOKEN = your_tmdb_read_access_token
   ```
2. Open `Lumiere.xcodeproj` and build. The token is read from the generated `Info.plist` at runtime.

Tests decode bundled fixtures and never hit the network, so they run without a token:

```bash
xcodebuild test -scheme Lumiere \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Status

v1.0 — the six screens above are complete and the app runs on device.

Next: dark theme, Dynamic Type across the custom fonts, animated crane states for loading and empty lists, and a mood field where you describe what you feel like watching in plain language and an LLM turns it into a query.

## License

MIT — see [LICENSE](LICENSE).
