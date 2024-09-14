# TestTask

## Project Overview
**TestTask** is a sample iOS project created as a test assignment for an iOS developer. It demonstrates the ability to handle POST/GET requests for fetching a list of users and registering new ones.

## Technologies and Libraries Used
The project is built using the following technologies and frameworks:
- **UIKit**
- **MVVM architecture**
- **GCD (Grand Central Dispatch)**
- **Network framework**
- **Foundation**
- **URLSession** for networking
- **AutoLayout** for building the UI programmatically

## Project Setup
To get the project up and running, you need:
1. **Xcode**: Make sure you have Xcode installed on your machine (version X or higher).
2. Clone the repository to your local machine using:
   ```bash
   git clone https://github.com/nPoway/TestTask.git
Open the TestTask.xcodeproj file in Xcode.
Build the project using Cmd + B or click on the Build button in Xcode.
Running the Project

Ensure you have a stable internet connection, as the app requires internet to make API requests.
Run the project by selecting your target device or simulator and pressing Cmd + R.
The app supports iOS devices and simulators starting from iOS 16.0.
Special Configuration

The app requires permission to access the camera for uploading user profile pictures. Make sure to grant the necessary permissions when prompted. Additionally, ensure your device has a stable internet connection to handle API requests.

Potential Issues and Troubleshooting

Here are some common issues that might arise and their possible solutions:

No internet connection:
The app relies on network requests for fetching and registering users. If there's no network connection, a "No Connection" screen will appear. Please ensure you are connected to the internet.
Camera permissions:
If camera access is not granted, the app will not be able to capture photos for user registration. You can enable camera access in the device's settings.
Token expiration during registration:
If the user token becomes invalid, the app will attempt to fetch a new token automatically and retry the registration process.
Server-side errors:
Any server-side errors (such as invalid user data or an existing user) will be displayed in the UI.
Development Time and Challenges

The project took approximately 12 hours to complete.
The most challenging part was working with the Network framework as I didn't have much prior experience with it.
Contribution Guidelines

This is a test assignment, so contributions are not required at this time. However, if you want to explore the code or report any issues, feel free to clone the repository and submit issues or pull requests.

Feel free to reach out if you have any questions or feedback!
