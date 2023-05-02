# School Life (AIPProject)

Our goal is to create an Avon Webapp that includes lost and found, school store, daily schedule, sports information, and food menu features.

## application review

### dashboard (main menu)
It is going to be different for student, not logged in user and administrator.
Student main menu will have (undefined)
Administrator main menu will have (undefined)

### daily schedule
The url is going to be posted in the server.
In the app, by using flutter_webview package, that website is going to be displayed.

### lost and found
The administrator is going to post the lost items.
The lost and found items are going to be displayed in the app.
The users can find  the lost item by searching in the search bar.

### food menu
The data of the food menu is going to be parsed from https://avonoldfarms.flikisdining.com/.
In the app, food menu of the day, day before, and after will going to be available.

### school store (hawk's nest)
The administrator is going to post the school store item.
The items are going to be categorized by FOOD, DRINK, GOODS, or OTHER.

### sports
The data of the sports is going to be parsed from https://www.avonoldfarms.com/athletics/teams-schedules.
In the app, the page will show the upcoming game schedule and previous game results.
The number of upcoming game schedule and previous game results to show can be changed in setting.
The users can star(check) the sports that they want to display.
Below the game results, users can check sports informations such as coach info or roaster.

## Flutter Setup

Follow the steps in the [Flutter Setup](#flutter-setup) section to set up Flutter on macOS.

### Downloading Flutter for macOS

1. Open Terminal and change directory to Downloads:
  ```
  cd ~/Downloads
  ```

2. Download the Flutter SDK:
- For Intel chip:
  ```
  curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.7.12-stable.zip
  ```

- For M1 chip:
  ```
  curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.7.12-stable.zip
  ```

3. Change directory to your development folder:
  ```
  cd ~/development
  ```
  
4. Unzip the downloaded file and remove the zip file:
  ```
  unzip ~/Downloads/flutter_macos_3.7.12-stable.zip
  rm -r ~/Downloads/flutter_macos_3.7.12-stable.zip
  ```
  
5. Add Flutter to your PATH:
  ```
  export PATH="$PATH:pwd/flutter/bin"
  ```

6. Check your shell:
  ```
  echo $SHELL
  ```

7. Open your shell configuration file based on the output:
- If output is bin/bash:

  ```
  open $HOME/.bash_profile
  ```

- If output is bin/zsh:

  ```
  open $HOME/.zshrc
  ```

8. Add the following line to the end of your shell configuration file:
  ```
  export PATH="$PATH:~/flutter/bin"
  ```
  
9. Verify that the PATH is successfully added:
  ```
  echo $PATH
  ```

10. Check that the `flutter` command is available:
 ```
 which flutter
 ```

## Project Structure
- admin
  - edit_daily_schedule.dart
  - edit_lost_and_found.dart
  - edit_school_store.dart
  - main_menu.dart
- api_service
  - api_service.dart
  - authenication.dart
  - exceptions.dart
- auth
  - login.dart
- data
  - daily_schedule.dart
  - data.dart
  - food_menu.dart
  - lost_item.dart
  - school_store.dart
  - settings.dart
  - sharedPreferenceStorage.dart
  - sports.dart
  - user_.dart
- firebase_options.dart
- main.dart
- pages
  - daily_schedule.dart
  - food_menu.dart
  - lost_and_found.dart
  - main_menu.dart
  - notifications.dart
  - school_store.dart
  - sports.dart
- utils
  - loading.dart
- widgets
  - assets.dart


## Dependencies

To download the required dependencies, run `flutter pub get`. The dependencies are as follows:

- dependencies:
  - flutter:
    - sdk: flutter
  - google_sign_in: ^6.1.0
  - firebase_core: ^2.10.0
  - firebase_auth: ^4.2.2
  - http: ^0.13.5
  - intl: ^0.18.1
  - url_launcher: ^6.0.17
  - flutter_linkify: ^5.0.2
  - shared_preferences: ^2.1.0
  - cupertino_icons: ^1.0.2
  - flutter_svg: ^2.0.5
  - firebase_core_platform_interface: ^4.6.0
  - firebase_core_dart: ^1.0.1
  - flutter_launcher_icons: ^0.13.1
  - firebase_crashlytics: ^3.1.1
  - flutter_html: ^0.11.1
  - style: ^0.0.5
  - webview_flutter: ^4.2.0
  - webview_flutter_wkwebview: ^3.4.0
  - cached_network_image: ^3.2.3
