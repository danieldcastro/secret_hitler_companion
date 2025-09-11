# Secret Hitler Companion 🥸

> 🇧🇷 Read this in [**Português**](README.pt_BR.md)

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev/)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
![Status](https://img.shields.io/badge/status-in%20progress-orange)
[![Shorebird](https://img.shields.io/badge/Shorebird-OTA%20updates-00BFA6?logo=bird)](https://shorebird.dev/)
[![Crowdin](https://badges.crowdin.net/badge/light/crowdin-on-dark.png)](https://crowdin.com/project/secret-hitler-companion)

A companion app for the board game **Secret Hitler**, designed to make the game sessions more immersive and organized.

⚠️ **Important:** This app **does not replace the board game**.  
You need the **official Secret Hitler physical board game** to use the app.

📌 **Project status:** In progress (MVP).  
Features may change rapidly until the stable version.

## ✨ Features

- 🎭 **Role distribution**: automatic and secret assignment of each player's role.  
- 🎙️ **Automated narration**: guides each phase of the game (Night, Election, Voting, Presidential Powers, etc.).  
- 📖 **Integrated rules**: quick reference to the official rules.  
- 🎵 **Background music and sound effects**: music and sounds triggered at specific moments.  
- 🧑‍🤝‍🧑 **Player management**: register player names to streamline the game flow.  
- 👅 **Multi-language translation**: collaborative translation system via [Crowdin](https://crowdin.com/).  

## 🛠️ Technologies

- [Flutter](https://flutter.dev/) — Main framework  
- [Dart](https://dart.dev/) — Base language  
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — State management  
- [flutter_modular](https://pub.dev/packages/flutter_modular) — Modularization and dependency injection  
- [melos](https://melos.invertase.dev/) — Build scripts  
- [Shorebird](https://shorebird.dev/) — Deployment and **OTA updates** (over-the-air updates) 

## 🚀 How to run the project

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine  
- Dart SDK included  

### Steps
```bash
# Clone the repository
git clone https://github.com/danieldcastro/secret-hitler-companion.git

# Go to the project folder
cd secret-hitler-companion

# Install dependencies
flutter pub get

# Run the app
flutter run
````

## 📌 Roadmap

* [ ] Home screen with navigation menu
* [ ] Player registration flow
* [ ] Role distribution system
* [ ] Guided round narration
* [ ] Themed sounds and music
* [ ] Multi-language translation via Crowdin
* [ ] OTA updates and CI deployment via Shorebird

## 🤝 Contributions

Contributions are welcome!
Open an **issue** for suggestions or bug reports, or send a **pull request** with improvements.

If you want to help with **app translation**, participate via [Crowdin](https://crowdin.com/).

## ⚖️ License

This project is only an **unofficial companion** for the game Secret Hitler.
Secret Hitler was created by Max Temkin, Mike Boxleiter, and Tommy Maranges.

This app is a **non-commercial, open source project**, with no official affiliation with the game's creators.

Licensed under the MIT License.

## 🎲 Enjoy playing Secret Hitler with a more immersive digital experience!

👉 [Learn more about Secret Hitler](https://www.secrethitler.com/)
