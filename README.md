# QRReader
QR Code reader app

# Commit format
For commit format we're using emoji codes that can be found here - https://github.com/dannyfritz/commit-message-emoji.

## Running the App Locally
- Clone the repo from GitHub (the *Master* branch is the latest stable release)
- Install the pods (Swift 3rd party libraries)
    - Install the *cocoapods* ruby gem
        - https://guides.cocoapods.org/using/getting-started.html
        - Run the command `pod --version` in the Terminal to check if cocoapods is installed
    - Run the *pod install* command from the project directory
- Open the *.xcworkspace* file

## Notes

When app detects valid QR code with valid URL - it's going to automatically open WebView with that link, otherwise it will throw a warning.


# Screenshots

## Onboarding
<p float="center">
  <img src="Screenshots/0.png" width="250" />
  <img src="Screenshots/1.png" width="250" /> 
</p>

## Empty states
<p float="center">
  <img src="Screenshots/2.png" width="250" />
  <img src="Screenshots/4.png" width="250" /> 
</p>

## Checkin - native flow
<p float="center">
  <img src="Screenshots/3.png" width="250" />
  <img src="Screenshots/5.png" width="250" /> 
  <img src="Screenshots/7.png" width="250" /> 
  <img src="Screenshots/8.png" width="250" /> 
</p>

## Account 
<p float="center">
  <img src="Screenshots/9.png" width="250" />
  <img src="Screenshots/10.png" width="250" /> 
</p>

## QR Scanning confirmation 
<p float="center">
  <img src="Screenshots/11.png" width="250" />
</p>

## Loading state
<p float="center">
  <img src="Screenshots/12.png" width="250" />
</p>

## Web checkin
<p float="center">
  <img src="Screenshots/13.png" width="250" />
</p>

## Error state
<p float="center">
  <img src="Screenshots/6.png" width="250" />
</p>
