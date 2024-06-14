### Welcome to Dictionary!

<p align="center">
  <img src="https://github.com/NecatiAlperen/dictionary/assets/109997859/4863eb54-72a5-4c00-b17b-7f393325898b" width="150" height="150">
</p>

<div align="center">
  <h1>Dictionary TGY-Bootcamp Final Project by Necati Alperen IŞIK</h1>
</div>

Dictionary is the perfect companion for those who want to learn new words and gain comprehensive knowledge about them. With this application, you can:

- **Discover Words**: Easily search for and discover new words.
- **Meaning Depth**: Learn the meanings, origins, and various usages of words.
- **Pronunciation Listening**: Listen to the correct pronunciations of words and improve your pronunciation skills.
- **Synonyms and Antonyms**: Learn synonyms and antonyms to enrich your vocabulary.
- **Usage in Sentences**: See how words are used in sentences and reinforce your language skills with example sentences.

Expand your vocabulary, enhance your language skills, and make your learning process more enjoyable with Dictionary!

## Table of Contents
- [Features](#features)
  - [Screenshots](#screenshots)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)


## Features

 **Search Every Word in English:**
- Explore every word and its details by searching them.
  
 **See In-Depth Information About Words:**
- In the Detail View of the word, you can see synonyms, browse information using the Safari Web View.

## Screenshots

| Empty Home View                | Detail View                | Safari View                | Recent Search View                |
|------------------------|------------------------|------------------------|------------------------|
| ![noresult](https://github.com/NecatiAlperen/dictionary/assets/109997859/a4ec1fe5-5a09-443e-9a77-911e6f15927a) | ![detail](https://github.com/NecatiAlperen/dictionary/assets/109997859/1fa57d46-9d16-42ac-80b7-abb1f08dc88f) | ![webview](https://github.com/NecatiAlperen/dictionary/assets/109997859/a96c43df-0950-45dc-8dfe-3025793582bd) | ![recentsearch](https://github.com/NecatiAlperen/dictionary/assets/109997859/b58781bd-9633-41fb-898c-a570e57c27fa) |

### Video

[Dictionary App Overview](https://github.com/NecatiAlperen/dictionary/assets/109997859/135d7f2c-31a9-4fa2-81f3-457b0c55b3d7)

## Tech Stack

- **Xcode:** Version 15.3
- **Language:** Swift 5.10
- **Minimum iOS Version:** 17.2
- **Dependency Manager:** SPM
- **3rd Party Dependencies:**
  - **Alamofire (5.9.1):** Used for making network requests.
  - **Lottie (4.4.3):** Used for adding beautiful animations.

## Architecture

![0__yROVSX66gWLOARU](https://github.com/NecatiAlperen/dictionary/assets/109997859/589afffc-a49b-461b-b619-601570e0c04d)

In Dictionary's development, VIPER (View-Interactor-Presenter-Entity-Router) architecture is being used for these key reasons:

- **Better Maintainability:**  VIPER ensures a clear division between presentation logic, business logic, and app navigation, making the codebase easier to manage and update as the application grows.
- **Enhanced Testability:** Separating business logic from UI components allows for more effective unit testing. Developers can concentrate on testing the interactor and presenter logic without being concerned about the user interface.
- **Increased Modularity:** VIPER promotes modularity by dividing concerns into separate layers, leading to a more organized and efficient development process.

## Nice to Have

- **Chat bot**
- **Favorites**
