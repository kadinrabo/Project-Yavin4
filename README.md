# :camera: Screenshots

<img src="https://drive.google.com/uc?export=view&id=12T2aVxEXBBsI1H6mqiEOx5DLmKukrr2g" height=300> <img src="https://drive.google.com/uc?export=view&id=1D5suruhjwoEAScFb-k3RrRid0LvlP7iO" height=300> <img src="https://drive.google.com/uc?export=view&id=1WEVzSiJ9IFEvCTm6k28wOS-UAOroatPq" height=300>

<img src="https://drive.google.com/uc?export=view&id=1wyGUshlzZA3yqM2y54Q1JZgh_pOmkdXS" height=300> <img src="https://drive.google.com/uc?export=view&id=1_NCdn6uUTqhIVY01i2rxAjVpBXCmU_Wr" height=300> <img src="https://drive.google.com/uc?export=view&id=1YOIFJzPynHHwM7JOtnm8JYJvDAtVYycu" height=300>

<img src="https://drive.google.com/uc?export=view&id=1MYxcH8gBZnvEtQJDNkalt5RoO5aNyVcW" height=300> <img src="https://drive.google.com/uc?export=view&id=13SM-6iys1REtIxvDo2ooAMR8TYQmHD9B" height=300> <img src="https://drive.google.com/uc?export=view&id=1sd_uZr7A9AqjrrdsErHOeDeqYALGnTgm" height=300>

<img src="https://drive.google.com/uc?export=view&id=1HBeq0vakEB6V4Jz8INST5DIzj_NkZRxM" height=300> <img src="https://drive.google.com/uc?export=view&id=1y8NjpGWTcE7tsVln6zcLMIipaRmqeku1" height=300> <img src="https://drive.google.com/uc?export=view&id=1Ybi1GBASIga9Wj1Sm11VR6k2oYxocyR8" height=300> <img src="https://drive.google.com/uc?export=view&id=1nHe4Xo-ZrN39YtTUNroyicL1wT7cNq6J" height=300> <img src="https://drive.google.com/uc?export=view&id=1zuDlWXbDaIqSqfJiUDS_7G0t2ZF2m_4u" height=300>


# :crystal_ball: Models

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

# :art: Layout Documentation & Notes

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1UmEFcVcvbqeRBV7QlhQRIkannwk5jgOr" width=600 height=800>
</p>
