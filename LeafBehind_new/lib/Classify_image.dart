import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class ClassifyImage extends StatefulWidget {
  // image path is the path of the image that is taken by the camera or the image that is chosen from the gallery
  final String imagePath;

  const ClassifyImage({super.key, required this.imagePath});

  @override
  // ignore: library_private_types_in_public_api
  _ClassifyImageState createState() => _ClassifyImageState();
}

class _ClassifyImageState extends State<ClassifyImage> {

  // postCount is 1 because the user is going to post a new post now 
  int postCount = 1;
  // url is used to upload the image to the firebase storage
  String? url;
  // imageFile is the image that is taken by the camera or the image that is chosen from the gallery
  //File? imageFile;
  // downloadUrl is used to download the image from the firebase storage 
  dynamic downloadUrl;
  // pickedFile is the image that is taken by the camera or the image that is chosen from the gallery
  //dynamic pickedFile;
  // isLeaf is used to check if the image is a leaf or not
  bool? isLeaf;
  //highestConfidenceLabel is the label that has the highest confidence
  String? highestConfidenceLabel;
  // highestConfidencePercentage is the percentage of the highest confidence label
  String? highestConfidencePercentage;
  
  // this function is used to upload the image to the firebase storage
  @override
  void initState() {
    super.initState();
    Tflite.close();
  }

  Future classifyImageDiseases(refToUser, refToContent, url) async {
    
    // loaded model is the model that was trained to classify the leaf diseases
    await Tflite.loadModel(
        model: 'assets/leaf_diseases_32_classes_GPU.tflite', labels: 'assets/leaf_diseases_32_classes_GPU.txt');

    var output = await Tflite.runModelOnImage(
        path: widget.imagePath,
        imageMean: 127.5, 
        imageStd: 127.5, 
        numResults: 24, 
        threshold: -1000000, 
        asynch: true 
        );

    // sort the output by confidence
    output?.sort((a, b) => b["confidence"].compareTo(a["confidence"]));
    //take the 3 highest confidence labels into a list
    List<String> highestConfidenceLabels = [];
    //take the 3 highest confidence into a list
    List<double> highestConfidencePercentages = [];
    // take the  3 highest confidence
    for (int i = 0; i < 3; i++) {
      highestConfidencePercentages.add(output![i]["confidence"]);
    }  
    // multiply the 3 highest confidence by 100 to get the percentage
    for (int i = 0; i < 3; i++) {
      highestConfidencePercentages[i] = (highestConfidencePercentages[i] * 100);
    }

    // take the  3 highest confidence labels
    for (int i = 0; i < 3; i++) {
      highestConfidenceLabels.add(output![i]["label"]);
    }
    // get the 3 highest confidence labels and the 3 highest confidence percentages 
    //and put them in a list to display them in the post
    String highestConfidenceLabelsString = "\n\n";
    for (int i = 0; i < 3; i++) {
      highestConfidenceLabelsString += "${i + 1}. ${highestConfidenceLabels[i]} ${highestConfidencePercentages[i].toStringAsFixed(2)}%\n\n";
    }

    // get the highest confidence label and the highest confidence percentage
    String highestConfidenceLabel = output![0]["label"];
    String highestConfidencePercentage = (output[0]["confidence"] * 100).toStringAsFixed(2);
    
    // ignore: avoid_print
    print(highestConfidenceLabel);
    // ignore: avoid_print
    print(highestConfidencePercentage);

      // downloadUrl is the url of the image that is uploaded to the firebase storage
      downloadUrl = url; // Update class-level variable
                            refToContent = refToUser.collection('Post $postCount').doc('Contents');
      
      this.highestConfidenceLabel = highestConfidenceLabel;
      this.highestConfidencePercentage = highestConfidencePercentage;

      // setting the data of the post in the firebase firestore
       refToUser.set(
                    {'postCount': postCount},
                    SetOptions(merge: true),
                  );
                  postCount++;
                   refToContent.set(
                    {'link': url},
                    SetOptions(merge: true),
                  );
                   refToContent.set(
                    {'Disease': highestConfidenceLabelsString},
                    SetOptions(merge: true),
                  );
                   refToContent.set(
                    {'Date': DateTime.now()},
                    SetOptions(merge: true),
                  );  
    

  }

  Future classifyImage() async {
    
    // loaded model is the model that was trained to classify whether the image is a leaf or not
    await Tflite.loadModel(
        model: 'assets/anything_vs_leaf.tflite', labels: 'assets/anything_vs_leaf.txt');
    var output = await Tflite.runModelOnImage(
        path: widget.imagePath,
        imageMean: 127.5, 
        imageStd: 127.5, 
        numResults: 2, 
        threshold: 0.05, 
        asynch: true 
        );

    // if the image is not a leaf, then the user will be notified to take a picture of a leaf

    if (output![0]['label'][0] == "1") {
      // ignore: avoid_print
      print(output[0]['label'][0]);
      // ignore: avoid_print
      print("Not Leaf");
      isLeaf = false;
      
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Warning"),
            content:
            const Text("This is not a leaf. Please take a picture of a leaf."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } 
    // else, the image is a leaf and the user will be notified to upload the image
    else {
      // ignore: avoid_print
      print(output[0]['label'][0]);
      // ignore: avoid_print
      print("Leaf");
      isLeaf = true;
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Image Upload"),
            content:
              const Text("Please click the OK button to upload the image."),
            actions: [
              TextButton(
                onPressed: () async{       

                  //Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/PreviousPosts');
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // _getData is a function that gets the post count of the user 
  // and increments it by 1 to be used as the post number of the user
  _getData(var refToUser) async {
    var response = await refToUser.get();
    if (response.exists) {
      var map = response.data();
      postCount = map!['postCount'];
    } else {
      await refToUser.set({'postCount': 0});
      postCount = 0;
    }
    postCount++;
    // ignore: avoid_print
    print(postCount);
  }

  // the UI of the image preview screen
  @override
  Widget build(BuildContext context) {
    var refToUser = FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid);
    var refToContent = refToUser.collection('Post $postCount').doc('Contents');

    _getData(refToUser);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Action when "Classify the image" button is pressed
                  // ignore: avoid_print
                  print('Classify the image button pressed');
                  await classifyImage();
                  if (isLeaf == true)
                  {
                  
                  Reference storageRef = FirebaseStorage.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Post $postCount');

                  final uploadTask = storageRef.putFile(File(widget.imagePath));
                  final snapshot = await uploadTask.whenComplete(() {});
                  var url = await snapshot.ref.getDownloadURL(); // Assign value to url
                  // ignore: avoid_print
                  print('Download URL: $url');   
                                        
                  classifyImageDiseases(refToUser, refToContent, url);
                  }                 
                },
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)), // Set the desired background color
                ),
                child: const Text('Classify the image'),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}