<p align="center">
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/7bdec772-00ec-4e40-925d-5140dd921191"alt="playstore" width="200" height="200">
</p>

# Leaf Behind

Leaf Behind is a comprehensive project aimed at leaf image detection and disease classification using Python and Dart. This repository contains implementations for image detection of leaves versus anything, as well as the detection of diseases in leaves. Additionally, it includes a mobile application built with Dart for easy access and usage.

## Features

<p align="center">
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/a6d160a5-cf4b-422f-a604-4b363cd041c0 "alt="playstore" width="400" height="800">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/dc8a8800-2417-4f80-8a8e-9e7c24ecbaf1 "alt="playstore" width="400" height="800">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/4e9cc72b-3dbb-4e3f-b3e2-c8fd6e4840a0 "alt="playstore" width="400" height="800">
</p>


### Image Detection of Leaves vs Anything (Python)

- **Data Collection**: Gathered 6584 images for the "Anything" dataset from Google images and a Kaggle Dataset.
- **Code Implementation**: Python code for image detection of leaves versus anything.

### Image Detection of Diseases of Leaves (Python)

- **Data Collection**: Obtained 6585 images for the "Leaves" dataset from Google images and a Kaggle Dataset.
- **Code Implementation**:
  - Implemented code for image detection of diseases of leaves with 24 classes on CPU.
  - Implemented code for image detection of diseases of leaves with 32 classes on GPU.

### Creating Mobile Application (Dart)

- Developed a mobile application using Dart for easy access to leaf image detection and disease classification functionalities.

## Image Detection of Diseases of Leaves Details

- Utilized Google Colab for training 32 classes on GPU.
- Trained the model for 25 epochs using 112,232 images.
- Dataset distribution:
  - 67,352 images for training
  - 22,425 images for validation
  - 22,425 images for testing
- Achieved a model accuracy of 62% after 25 epochs of training.
- Attained an evaluation accuracy of 78% when tested against the validation dataset.

## Database

- User login information is securely stored in Firebase Authentication.
- Uploaded images are stored in Firebase Storage for easy retrieval.
- User history information is stored in Cloud Firestore for efficient tracking and management.
