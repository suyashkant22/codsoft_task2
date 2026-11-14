# codsoft_task2
Completed 3 Android Application Development tasks as part of the CODSOFT Virtual Internship, gaining hands-on experience in Flutter, Dart, and mobile app development.

# Quote of the Day App

A simple Flutter app that shows a new inspiring quote every day and lets users save and share their favorites.

## Features

- **Home Screen:** Displays the inspiring quote of the day on a gradient background with an animated quote card.
- **Quote Refresh:** The quote updates automatically each day (chosen from the current date) and on every app launch. A "New" button shows a random quote on demand.
- **Share Quote:** A share sheet with WhatsApp, Instagram, Telegram, Messages and Copy options. The quote is copied to the clipboard, ready to paste.
- **Favorite Quotes:** Tap the heart to save or remove a quote. A badge shows the number of favorites, and the Favorites page lets users view and delete saved quotes.
- **User Interface:** Clean Material 3 design, gradient theme, smooth transitions and snackbar feedback.

## Run in DartPad

1. Open [dartpad.dev](https://dartpad.dev).
2. Make sure a Flutter channel is selected.
3. Paste the contents of `main.dart` and click **Run**.

## Run in a Flutter Project

1. Create a project: `flutter create quote_of_the_day`
2. Replace `lib/main.dart` with the `main.dart` from this repository.
3. Run: `flutter run`

## Project Structure

| File | Purpose |
|------|---------|
| `main.dart` | Complete app: quote model, home screen, share sheet, favorites page |
| `README.md` | Project description |

## Known Limitations

- Favorites are kept in memory only, so they reset when the app restarts.
- Sharing copies the quote to the clipboard instead of opening other apps directly.

## Future Improvements

- Save favorites with the `shared_preferences` package.
- Use the `share_plus` package for the native share sheet.
- Fetch quotes from an online API.
- Add daily notification reminders.

## Tech Stack

- Dart
- Flutter (Material 3)
- 
