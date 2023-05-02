# AIPProject
Our goal is to make Avon Webapp that has function of lost and found, school store, daily schedule, sports informations, and food menu

## flutter setup
# Downloading flutter for macOS (https://docs.flutter.dev/get-started/install/macos)
1. cd ~/Downloads

 - if intel chip
 2. curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.7.12-stable.zip
 - if m1 chip
 2. curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.7.12-stable.zip

3. cd ~/development
4. unzip ~/Downloads/flutter_macos_3.7.12-stable.zip | rm -r ~/Downloads/flutter_macos_3.7.12-stable.zip
5. export PATH="$PATH:`pwd`/flutter/bin"
6. echo $SHELL 

 - if output is bin/bash 
 7. open $HOME/.bash_profile
 - if Z shell bin/zsh
 7. open $HOME/.zshrc
 
8. At the end of the line, add line:
 - export PATH="$PATH:~/flutter/bin"
9. check the path is succesfully added
 - echo $PATH
10. Verify that the flutter command is available by running
 - which flutter