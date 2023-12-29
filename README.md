# TryNote: Flutter Notepad App

## Overview:
TryNote is a feature-rich Flutter Notepad app designed to provide users with a simple and powerful note-taking experience. Leveraging the Flutter framework, the app incorporates GetX for efficient state management, SQLite for local data storage, and Firebase for user authentication and cloud-based functionalities.

## Main Features:

### 1. Home Screen (home.dart):
- Displays a list of notes retrieved from the SQLite database.
- Allows users to add, remove, and mark favorite notes.
- Utilizes GetX for efficient state management and UI updates.

#### Home Screen:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/eaffc5ee-1606-4090-9257-ffea7355ccc9" width="277" height="600" />

### 2. Add Note Screen (addnote.dart):
- Enables users to add new notes with a title and content.
- Responsive and user-friendly interface.
- Utilizes SqlDb class for inserting new notes into the SQLite database.

#### Add Note Screen:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/bafb9958-550e-4db7-aa80-391c8abb4252" width="277" height="600" />

### 3. SQLite Database Operations (sqldb.dart):
- Manages CRUD operations for the SQLite database.
- Implements methods for reading, inserting, updating, and deleting notes.
- Provides a simple and efficient way to interact with the database.

### 4. State Management (homecontroller.dart):
- Utilizes GetX for state management on the home screen.
- Includes methods for incrementing and decrementing note count (for demonstration purposes).

### 5. Home Screen Interaction:
- Allows users to mark favorite notes on the home screen.
- Supports removal of notes by swiping right or left.

#### Home Screen Interaction:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/17541c00-9f71-42c6-9d28-552750649bc7" width="277" height="600" />

### 6. Favorite Screen:
- Displays only favorite notes.
- Allows removal of favorite notes by swiping.

#### Favorite Screen:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/5927867e-87df-48d4-8467-c2cf5168a1d7" width="277" height="600" />
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/dd4da45d-85fb-4494-9a98-f45f7e5c944c" width="277" height="600" />

### 7. Add Note Screen Enhancements:
- Supports automatic text direction change for Arabic input.

#### Add Note Screen Enhancements:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/f9413039-e4e1-4d87-a684-7535c151f6d8" width="277" height="600" />

### 8. Account Page:
- Shows profile picture, name, and email from Firebase server.
- Includes options to logout and edit profile details.

#### Account Page:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/9ee8aa42-d726-4f4e-85d2-bb09aec06142" width="277" height="600" />
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/35af7aec-a40b-4dd7-b75c-ea84880371da" width="277" height="600" />
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/48608a14-bf40-488b-b9b1-4c6b5efae311" width="277" height="600" />

### 9. Signup Screen:
- Guides users through email and password setup.
- Performs email verification and facilitates username and profile picture selection.

#### Signup Screen:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/907d838f-5415-4ac5-9c3f-a8bc461f3047" width="277" height="600" />
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/78857a3f-81fa-460f-a792-ccfcd64f41c2" width="277" height="600" />
<img src="https://https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/9ea7926c-95fa-4942-9a5f-fb7f2bb0b5fc" width="277" height="600" />

### 10. Login Page:
- Enables entry via email and password or Google account sign-in.
- Automatically adds the username to the Google email name.

#### Login Page:
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/99d26b30-041a-4579-ac29-cd39fed4cabc" width="277" height="600" />
<img src="https://github.com/A7medMajed16/Notepad_app_Flutter_Getx_Sql/assets/86576698/1d6c538d-b45a-47c2-a705-0b614a9092a7" width="277" height="600" />

## How to Use:
1. Clone the repository.
2. Open the project in your preferred Flutter development environment.
3. Run the app on an emulator or physical device.

## Dependencies:

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
| cached_network_image   | ^3.3.0  |
| cloud_firestore        | ^4.13.6 |
| firebase_app_check     | ^0.2.1+8|
| firebase_auth          | ^4.15.3 |
| firebase_core          | ^2.24.2 |
| firebase_storage       | ^11.5.6 |
| flutter_svg            | ^2.0.9  |
| google_sign_in         | ^6.2.1  |
| image_picker           | ^1.0.5  |
| rive                   | ^0.12.3 |
| flutter_lints          | ^3.0.1  |

---

**Note:** The code is protected by GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007.

**GitHub Repository:** [Link to GitHub Repository]

*For more details, refer to the documentation and codebase.*

---
*Disclaimer: This README file is a suggested edit and may need to be customized based on specific project details and preferences.*
