# :crystal_ball: Models

### **Controllers** :arrow_right: **Sections** :arrow_right: **Items**

### **Stages** :arrow_right: **Stage** :arrow_right: **Workout**

#### **Section**

Property | Description
------------ | -------------
type | Non-optional for specifying type of section. Corresponds to a cell.
identifier | For pushing to other view controllers in view delegate.
title | Title of a cell.
subtitle | Subtitle of a cell.
data | Multiple items in single section.

#### **Item**

Property | Description
------------ | -------------
tag | Home Controller blue tag e.g. "NEW".
stage | Pushing to Stage Controller.
identifier | Showing correct workout by user press.
title | Title of workout or stage.
subtitle | Subtitle of a section item.
image | Corresponds to Firebase storage image.
description | For type of button on home page. Typically workout or article.
url | For articles in Resources section.

# :framed_picture: Views

* **Configure Hierarchy Method(s):** Sets up an empty UICompositionalLayout built from sections specified by identifier.

* **Configure Cells Method(s):** Calls the methods that register the cells with the data source and configure them with data.

* **Configure Data Method(s):** Simple method that fills each design property with *Item* object data.

* **Initialize Style Method(s):** Initializes the style of the cell.

# :joystick: Controllers

* **Root Delegate Method(s):** Contains all necessary method calls and basic page style. Initializes essential properties.

* **View Delegate Method(s):** Overrides function didSelectItemAt to change the scene based on what the user presses.

* **Button Delegate Method(s):** Typically contains @IBAction methods but can contain authorization logic.

* **Video Delegate Method(s):** AVPlayer logic for showing workout or landing page video with AVPlayerViewController. 

* **Data Delegate Method(s):** Typically contains logic to update data source snapshot and apply changes to data source. Logically the final step to show a view.

* **Validation Delegate Method(s):** Typically used for validating if the user is already logged in or not.

# :video_game: Usage

#### 1. Clone repository
#### 2. Initialize [Cocoa Pods](https://cocoapods.org) in terminal:
    pod init
    open Podfile
#### 3. Add pods to Podfile:
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'SDWebImage', '~> 5.0'
    pod 'Firebase/Firestore'
    pod 'FirebaseFirestoreSwift'
#### 4. Install pods in terminal:
    pod install
#### 5. Open xcworkspace

# :flower_playing_cards: Features

[Firebase Authentication](https://firebase.google.com/docs/auth) for basic user sign up flow.

[Cloud Firestore](https://firebase.google.com/docs/firestore) for user data documents (e.g. saved workouts).

[Firebase Realtime Database](https://firebase.google.com/docs/database) for json controller data.

[Cloud Storage for Firebase](https://firebase.google.com/docs/storage) for images and videos embedded in app.

[Model-View-Controller Architecture](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)

[Image Caching with SD_WebImage](https://github.com/SDWebImage/SDWebImage)

# :camera: Screenshots

<img src="https://drive.google.com/uc?export=view&id=1ss1yXyyHdgmgIVYAZ7ScDQPr2gh8BnlI" height=1040> <img src="https://drive.google.com/uc?export=view&id=1bXjgxvTtRs6W7JrYTfHmwbe1dAmgje6P" height=1040>

<img src="https://drive.google.com/uc?export=view&id=1pWevmaTly4BVD7S5J7JAZVVAs6FCiPTY" height=1040> <img src="https://drive.google.com/uc?export=view&id=11TsBpgoMLSfo5ciUziVcSnQrJht88JVS" height=1040>

<img src="https://drive.google.com/uc?export=view&id=1hLdYlKitlMV7TRTLb2BDfks72qgsqeQW" height=1040> <img src="https://drive.google.com/uc?export=view&id=1UUEGHEn-jXl36wndHnfIhKtFKGu96N59" height=1040>

<img src="https://drive.google.com/uc?export=view&id=1_nmLmUeT7w-ZbyFYmMK_KJR_EDwrTAUc" height=1040> <img src="https://drive.google.com/uc?export=view&id=1xZbL3QzbNH32TRaCMW7lPmBg9EAnSHjf" height=1040>

<img src="https://drive.google.com/uc?export=view&id=1bYGyPgbXV2xaIjpVdp_YN6YVnQa8Yetw" height=1040> <img src="https://drive.google.com/uc?export=view&id=1Ad5KvDmtJRD6tie0TBL6DvA6GhgPOOr4" height=1040>

<img src="https://drive.google.com/uc?export=view&id=1rXRJ5CD8tXdqlo7hvcjAotd4Ki_9RzvS" height=1040> <img src="https://drive.google.com/uc?export=view&id=1cEeD55CP9hLqqef-qiEFRtmAah56pbdF" height=1040>

# :art: Layout Documentation & Notes

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1FUAWkOhOgUr4T8oKKIY24s7aitKOe-zc" width=600 height=800>
  
  <img src="https://drive.google.com/uc?export=view&id=1XgpnChRiOA31tKiOLrj7C2hs5HAWJNp_" width=600 height=800>
</p>
