# PlantManiac App

Description of app is available on readme file on branch `develop` and here will be step by step guide how to download PlantManiac app in Xcode.

## Setting up a development environment
Since the app is built for the iOS environment, the first step is to install the Xcode development environment on your Mac.
1. Open the **App Store** on your Mac.  
2. Search for **Xcode**.  
3. Click **Get** and then **Install** to download the latest version.  
4. Once the installation is complete, open Xcode from the **Applications** folder.  
5. (Optional) If you need command-line tools, install them by running the following command in Terminal:  

   ```bash
   xcode-select --install

For downloading the application for development, there are several options, but the simplest one is downloading as a ZIP file.
1. Click the green **Code button** in the top-right corner of the repository.
2. Select **Download ZIP** from the dropdown menu (be careful because you need to be on the branch ``master``).
3. **Extract** (unzip) the downloaded file to your desired folder.
4. Open the extracted project folder in Finder.
5. Locate the .xcodeproj or .xcworkspace file (depending on whether the project uses CocoaPods).
6. Double-click the file to open it in Xcode. (or you)
7. Final step before testing the app is to download packages that the app uses. You can done that with SPM (Swift Package Manager) which is included in Xcode, and the packages are:
- **Firebase/Auth** – user registration and login  
- **Firebase/Firestore** – saving and retrieving notes, reminders, and plant data  
- **Combine** – reactive programming (built into iOS, no installation required)  
- **UserNotifications** – scheduling and managing local notifications (built into iOS)  
8. The last step is to select a simulator (e.g., iPhone 14) and press Run ▶ (Cmd + R) to build and launch the app.

If the errors occure while launching the app the problem is probably in packages.

**Note:** The application has not been tested to check if plant identification works when taking a photo directly, but only when selecting an image from the gallery.
