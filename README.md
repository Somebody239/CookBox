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

## Technology

- Swift
- SwiftUI
- Local iOS persistence (Core Data / SwiftData)
- Camera and Photo Library integration

## Getting started

1. Clone this repository.
2. Open `CookBox.xcodeproj` in Xcode.
3. Select an iOS simulator or a connected device.
4. Build and run the app.

## Project status

CookBox is currently under active development. The initial interface includes Home, Search, and Account tabs, with recipe creation, persistence, image attachment, and filtering planned as the app develops.
