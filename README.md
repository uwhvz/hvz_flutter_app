# UWHvZ Mobile Application

Cross platform mobile application for UWaterloo Humans vs Zombies, built using Flutter and Dart.

Development is ongoing.

## Setup Instructions

1. Clone the repository to your local device.

2. Download and install Flutter per the instructions [here](https://flutter.dev/docs/get-started/install). You will need one of:

   - Android Studio (for Android)
   - XCode (for iOS)

   The website has setup instructions for both IDEs.

3. Import the project, and run `flutter pub get`.

## FAQs

**I installed the Flutter and Dart SDKs. How come I still can't build?**

1. Try restarting your IDE - both Android Studio and XCode need to restart after installing the SDKs.
2. Check to see that you have a physical device, an emulator, or a simulator that you can deploy to.
3. In Android Studio, make sure you imported the project as a "Project" and not an "Android Project".

**How do I redirect the application to point to a different instance of the UWHvZ API?**

You have to change the testing server in `<app_directory>/lib/constants.dart`. Ensure that you change it back before committing.

**I have additional questions. Where can I get them answered?**

Please message the official [UWHvZ Facebook Page](https://www.facebook.com/uwhvz/) for support if it's urgent. Otherwise, leave an issue.



## Issues?

To leave feedback and/or requests, file an issue above. Be sure to search to see if the same issue has already been submitted. We will try and address it as quickly as possible.

## Contributing



To contribute, open a branch and submit a pull request. You must get at least one approving review from an authorized reviewer. The current authorized reviewers are:

- [Tiger Kong](https://github.com/tig567899)
- The current term's UWHvZ Webmaster
- [uwhvz](https://github.com/uwhvz)

## Known Issues:

## Under Development:

- Explanative dialog boxes for the home page
- QR scanning for reporting tags and stuns
- Adding rules and guides document