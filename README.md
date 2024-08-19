<p align="center">
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/7bdec772-00ec-4e40-925d-5140dd921191" alt="Leaf Behind Logo" width="200" height="200">
</p>

<h1 align="center">🌿 Leaf Behind 🌿</h1>

<p align="center">
  <em>A cutting-edge project leveraging machine learning for leaf image detection and disease classification.</em>
</p>

<p align="center">
  <strong>Technologies Used:</strong> Python, Dart, TensorFlow, Firebase
</p>

---

## 🌟 Overview

**Leaf Behind** is an innovative project focused on identifying and classifying leaf images, helping to detect diseases early. This repository showcases the entire lifecycle of the project, from image detection using Python to a user-friendly mobile application built with Dart.

---

## ✨ Features

<p align="center">
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/a6d160a5-cf4b-422f-a604-4b363cd041c0" alt="Mobile App Screenshot 1" width="300" height="600">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/dc8a8800-2417-4f80-8a8e-9e7c24ecbaf1" alt="Mobile App Screenshot 2" width="300" height="600">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/4e9cc72b-3dbb-4e3f-b3e2-c8fd6e4840a0" alt="Mobile App Screenshot 3" width="300" height="600">
</p>

### 🌱 Leaf vs Anything Detection (Python)

- **Data Collection**: Acquired **6,584** images for the "Anything" dataset from Google Images and Kaggle.
- **Implementation**: Developed Python code to distinguish between leaf images and other objects.

### 🌿 Disease Detection in Leaves (Python)

- **Data Collection**: Gathered **6,585** images for the "Leaves" dataset from online sources.
- **Model Implementation**:
  - **CPU**: Detection of leaf diseases across **24 classes**.
  - **GPU**: Enhanced detection for **32 classes** using GPU acceleration.

### 📱 Mobile Application Development (Dart)

- Created a mobile application using Dart, making it easier for users to detect leaf diseases and access results on-the-go.

---

## 📊 Detailed Insights on Disease Detection

- **Training Platform**: Google Colab (32 classes on GPU).
- **Training Details**: 
  - **Epochs**: 25
  - **Images**: 112,232
- **Dataset Breakdown**:
  - **Training**: 67,352 images
  - **Validation**: 22,425 images
  - **Testing**: 22,425 images
- **Performance**: 
  - **Model Accuracy**: 62% after 25 epochs.
  - **Validation Accuracy**: 78% on the validation dataset.

<p align="center">
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/62f7466c-6230-45a1-80ce-e745fbf69e8c" alt="Model Accuracy" width="800" height="500">
</p>

---

## 🗂️ Database Architecture

- **User Authentication**: Managed through Firebase Authentication.
- **Image Storage**: Stored securely in Firebase Storage.
- **User History**: Tracked and managed using Cloud Firestore.

<p align="center">
  <img src="https://github.com/SafakGun/FlutterProject-HTW/assets/99952412/fb27844f-432e-4b58-a499-ddc96693d629" alt="Database Structure" width="1000" height="200">
</p>

---

## 👥 Contributors

- **Şafak Gün**
- **Ali Yiğit Taş**
- **Mehmet Kuzucu**
