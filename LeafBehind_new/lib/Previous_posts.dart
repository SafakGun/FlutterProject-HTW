import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreviousPosts extends StatefulWidget {
  const PreviousPosts({Key? key}) : super(key: key);

  @override
  State<PreviousPosts> createState() => _PreviousPostsState();
}


class _PreviousPostsState extends State<PreviousPosts> {
  // db is used to access the database
  FirebaseFirestore db = FirebaseFirestore.instance;
  // username is used to store the username of the current user
  final username = FirebaseAuth.instance.currentUser?.displayName;
  // userid is used to store the userid of the current user
  final userid = FirebaseAuth.instance.currentUser?.uid;
  // postCount is used to store the number of posts the user has made
  int postCount = 0;
  // needsRefresh is used to check if the page needs to be refreshed
  bool needsRefresh = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    // Get the number of posts the user has made
    var refToUser = db.collection('Users').doc('$userid');
    var response = await refToUser.get();
    if (response.exists) {
      var map = response.data();
      // updates the postCount 
      setState(() {
        postCount = map!['postCount'];
      });
      // else if the user has not made any posts, set the postCount to 0
    } else {
      await refToUser.set({'postCount': 0});
      setState(() {
        postCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // get the data from the database
    var refToUser = db.collection('Users').doc('$userid');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "History of Posts",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                color: const Color.fromARGB(255, 0, 128, 0),
                onRefresh: () async {
                  // the refresh operation here
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {
                    _getData();
                  });
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    // get the data from the database as a stream of snapshots of the documents
                    // in the collection 'Users' 
                    stream: refToUser.snapshots(),
                    builder: (context, snapshot) {
                      // if there is an error, show the error message
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                        // if the connection is waiting, show the progress indicator
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff084864),
                          ),
                        );
                        // if the user hasn't made posts, show the message
                      } else if (postCount == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Center(
                              child: Text(
                                  "There are no previous posts to show.",
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.5),
                            ),
                          ],
                        );
                      }
                      // else show the list of posts
                       else {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: postCount,
                          itemBuilder: (context, index) {
                            var postIndex = postCount - index;
                            return FutureBuilder<DocumentSnapshot>(
                              future: refToUser
                                  .collection('Post $postIndex')
                                  .doc('Contents')
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                // if connection is waiting, show the progress indicator
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: Color(0xff084864),
                                  ));
                                }
                                // if there is an error, show the error message
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Something went wrong'));
                                }
                                // if the snapshot is empty, show the message
                                if (!snapshot.hasData ||
                                    snapshot.data?.data() == null) {
                                  return const Center(
                                    child: Text("No posts yet"),
                                  );
                                }

                                // the time since the post was made is calculated here
                                Map<String, dynamic> contents =
                                    snapshot.data!.data() as Map<String, dynamic>;
                                var time;
                                var seconds = DateTime.now()
                                    .difference(contents['Date'].toDate())
                                    .inSeconds;
                                var minutes = DateTime.now()
                                    .difference(contents['Date'].toDate())
                                    .inMinutes;
                                var hours = DateTime.now()
                                    .difference(contents['Date'].toDate())
                                    .inHours;
                                var days = DateTime.now()
                                    .difference(contents['Date'].toDate())
                                    .inDays;
                                var weeks = (days / 7).floor();
                                var months = (days / 30).floor();
                                var years = (days / 365).floor();
          
                                if (seconds < 60) {
                                  if (seconds == 1) {
                                    time = '$seconds second ago';
                                  } else {
                                    time = '$seconds seconds ago';
                                  }
                                } else if (minutes < 60) {
                                  if (minutes == 1) {
                                    time = '$minutes minute ago';
                                  } else {
                                    time = '$minutes minutes ago';
                                  }
                                } else if (hours < 24) {
                                  if (hours == 1) {
                                    time = '$hours hour ago';
                                  } else {
                                    time = '$hours hours ago';
                                  }
                                } else if (days < 7) {
                                  if (days == 1) {
                                    time = '$days day ago';
                                  } else {
                                    time = '$days days ago';
                                  }
                                } else if (weeks < 4) {
                                  if (weeks == 1) {
                                    time = '$weeks week ago';
                                  } else {
                                    time = '$weeks weeks ago';
                                  }
                                } else if (months < 12) {
                                  if (months == 1) {
                                    time = '$months month ago';
                                  } else {
                                    time = '$months months ago';
                                  }
                                } else if (years <= 1) {
                                  if (years == 1) {
                                    time = '$years year ago';
                                  } else {
                                    time = '$years years ago';
                                  }
                                } else {
                                  time = 'a long time ago';
                                }

                                // the disease data is extracted here to be displayed in the card
                                String disease = contents['Disease']; 

                                return Card(
                                    //make card clickable
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: const Color.fromARGB(255, 221, 249, 221),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: const Color.fromARGB(
                                                255, 221, 249, 221),
                                            title: Text(disease),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: 1,
                                                    // the image is displayed here
                                                    child: Image.network(
                                                      contents['link'],
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    time,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      const Color(0xFF5c9464),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Close',
                                                  style: TextStyle(
                                                    color: Color(0xFF084864),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            height: 120,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  const Positioned.fill(
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Color(0xFF084864),
                                                      ),
                                                    ),
                                                  ),
                                                  AspectRatio(
                                                    aspectRatio: 1,
                                                    // the image is displayed here
                                                    child: Image.network(
                                                      contents['link'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // the possible disease names are displayed here
                                                  const Text(
                                                    'Possible Results:',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(255, 0, 57, 4),


                                                    ),
                                                  ),
                                                  // the disease data is displayed here
                                                  Text(
                                                    disease,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    time,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}