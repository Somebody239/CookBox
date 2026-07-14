# CookBox

> **Your personal cookbook, always in your pocket.**

CookBox is a clean, ad-free iOS app for creating, organizing, and searching a personal recipe collection. Keep family recipes, your own creations, and saved favorites together instead of scattering them across notes, screenshots, messages, and browser tabs.

## Why CookBox?

Recipe websites often bury the dish you need under ads and unrelated content. CookBox is built around *your* recipes, making it quick to find what you want while meal planning or cooking at home.

## Planned features

- Create recipes with a title, ingredient list, and step-by-step instructions
- Attach a photo from the camera or photo library
- Browse saved recipes visually in one personal collection
- Search and filter recipes by name or ingredient
- Open a recipe to view every detail while cooking
- Store recipe data locally for private, offline access

## Built for home cooks

CookBox is for anyone who cooks regularly—from beginners building a recipe library to families preserving recipes passed down through generations. It is designed to be useful in the kitchen, where fast access and a distraction-free interface matter.

## Privacy and offline use

CookBox is intended to use local iOS persistence (Core Data or SwiftData), so recipes stay on the device and remain available without an internet connection. It only needs access to the camera or photo library when you choose to add a recipe image; it does not require GPS, Bluetooth, or a network connection.

## Testing without a paid Apple Developer membership

GitHub Actions builds an **unsigned** iPhone `.ipa` whenever you publish a GitHub Release. The file is attached to that release as `CookBox-unsigned.ipa`.

This is useful for personal testing, but it is not TestFlight and the IPA cannot be installed directly. Each tester must sign and sideload it with their own Apple ID using a tool such as AltStore or Sideloadly.

1. Open the repository's **Releases** page and download `CookBox-unsigned.ipa` from the latest release.
2. On a Mac or Windows computer, open AltStore or Sideloadly and connect the iPhone by USB.
3. Add the IPA, sign in with the tester's own Apple ID, and install it.
4. On the iPhone, trust the developer profile in **Settings → General → VPN & Device Management** if prompted.

Free Apple ID signing has Apple-imposed limits, including short-lived app certificates (typically seven days) and a small limit on active sideloaded apps. The tester will need to refresh or reinstall the app after the certificate expires. Do not share an Apple ID with testers.

The current testing build requires iOS 26 or later because CookBox uses SwiftUI's iOS 26 visual effects.

### Publish a testing build

1. Push the code you want to test to `main`.
2. On GitHub, create and publish a release with a version tag such as `v0.1.0`.
3. The **Build unsigned iOS IPA** workflow runs automatically and attaches the IPA to that release.
4. Wait for the workflow to finish successfully before downloading the asset.

You can also run the workflow manually from the **Actions** tab; its IPA is available as a workflow artifact rather than a public release download.

## Technology

- Swift
- SwiftUI
- Local iOS persistence (Core Data / SwiftData)
- Camera and Photo Library integration
- GitHub Actions for unsigned testing builds

## Getting started

1. Clone this repository.
2. Open `CookBox.xcodeproj` in Xcode.
3. Select an iOS simulator or a connected device.
4. Build and run the app.

## Project status

CookBox is currently under active development. The initial interface includes Home, Search, and Account tabs, with recipe creation, persistence, image attachment, and filtering planned as the app develops.
