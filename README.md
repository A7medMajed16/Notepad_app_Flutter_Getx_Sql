# Flutter Notepad App using GetX and SQLite

## Overview:
This Flutter Notepad app is a simple yet powerful note-taking application built using the Flutter framework. The app utilizes the GetX state management library for efficient state handling and SQLite as the database for storing notes.

## Project Structure:
The project is organized into the following structure:

## lib Folder:
controller: Contains the HomeController class, responsible for managing the state of the app.
data: Contains the SqlDb class, handling SQLite database operations.
main.dart: The entry point of the application, configuring the theme, routes, and initializing the app.
addnote.dart: Implements the screen for adding new notes.
home.dart: Implements the main screen for displaying and managing notes.

## Main Features:
### 1. Home Screen (home.dart):
Displays a list of notes retrieved from the SQLite database.
Allows users to add a new note or remove existing notes.
Utilizes GetX for state management and efficient UI updates.
### 2. Add Note Screen (addnote.dart):
Enables users to add a new note with a title and content.
Implements a responsive and user-friendly interface.
Utilizes the SqlDb class for inserting new notes into the SQLite database.
### 3. SQLite Database Operations (sqldb.dart):
Manages the SQLite database for CRUD operations (Create, Read, Update, Delete).
Implements methods for reading, inserting, updating, and deleting notes.
Provides a simple and efficient way to interact with the database.
### 4. State Management (homecontroller.dart):
Uses GetX for state management in the home screen.
Includes methods for incrementing and decrementing the note count (just for demonstration purposes).

##How to Use:
Clone the repository.
Open the project in your preferred Flutter development environment.
Run the app on an emulator or physical device.

## Dependencies

| Package                | Version |
|------------------------|---------|
| Dart                   | 3.2.0   |
| flutter                | 3.16.0  |
| cupertino_icons        | ^1.0.2  |
| flutter_launcher_icons | ^0.13.1 |
| get                    | ^4.6.6  |
| google_fonts           | ^6.1.0  |
| path                   | ^1.8.3  |
| shared_preferences     | ^2.2.2  |
| sqflite                | ^2.3.0  |

Feel free to explore and customize the code to meet your specific requirements. Happy coding!
