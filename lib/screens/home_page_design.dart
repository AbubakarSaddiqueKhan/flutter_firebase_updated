import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_youtube/firestore_data.dart';
import 'package:flutter_firebase_youtube/screens/upload_image.dart';

class HomePageDesign extends StatefulWidget {
  const HomePageDesign({super.key});

  @override
  State<HomePageDesign> createState() => _HomePageDesignState();
}

class _HomePageDesignState extends State<HomePageDesign> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page Design"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //  send data to data base
              ElevatedButton(
                  onPressed: () async {
                    CollectionReference users = firebaseFirestore
                        .collection(FirebaseFireStoreData.COLLECTION_NAME);

                    //   user contain's the collection name here you can add document name and further data
                    //  the data in set must be in map {key : value} pair

                    await users.doc(FirebaseFireStoreData.DOCUMENT_NAME).set({
                      FirebaseFireStoreData.FIRST_ID_NAME:
                          FirebaseFireStoreData.FIRST_VALUE,
                      FirebaseFireStoreData.SECOND_ID_NAME:
                          FirebaseFireStoreData.SECOND_VALUE,
                      FirebaseFireStoreData.THIRD_ID_NAME:
                          FirebaseFireStoreData.THIRD_VALUE,
                    });

                    //  add one other document in above collection

                    await users
                        .doc(FirebaseFireStoreData.SECOND_DOCUMENT_NAME)
                        .set({
                      FirebaseFireStoreData.SECOND_DOCUMENT_FIRST_ID_NAME:
                          FirebaseFireStoreData.SECOND_DOCUMENT_FIRST_VALUE,
                      FirebaseFireStoreData.SECOND_DOCUMENT_SECOND_ID_NAME:
                          FirebaseFireStoreData.SECOND_DOCUMENT_SECOND_VALUE,
                      FirebaseFireStoreData.SECOND_DOCUMENT_THIRD_ID_NAME:
                          FirebaseFireStoreData.SECOND_DOCUMENT_THIRD_VALUE,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Data Added Successfully")));
                  },
                  child: Text(
                    "Add data to firebase",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  )),

              ElevatedButton(
                  onPressed: () async {
                    CollectionReference users = firebaseFirestore
                        .collection(FirebaseFireStoreData.COLLECTION_NAME);
                    //  fetch data from all of the documents of that collection
                    QuerySnapshot fethchDocumentsData = await users.get();
                    fethchDocumentsData.docs
                        .forEach((DocumentSnapshot documentSnapshot) {
                      print(documentSnapshot.data());
                    });

                    //  fetch data of the specific document
                    DocumentSnapshot fetchData = await users
                        .doc(FirebaseFireStoreData.SECOND_DOCUMENT_NAME)
                        .get();

                    print(fetchData.data());

                    //  used to listen any change in the data of the given document
                    //  listen if there any change or update in the document's data
                    users
                        .doc(FirebaseFireStoreData.DOCUMENT_NAME)
                        .snapshots()
                        .listen((event) {
                      print(event.data());
                    });
                  },
                  child: Text(
                    "Read Data From Firebase",
                    style: TextStyle(color: Colors.brown, fontSize: 20),
                  )),

              //  Update some field data of any document in the collection
              ElevatedButton(
                  onPressed: () async {
                    firebaseFirestore
                        .collection(FirebaseFireStoreData.COLLECTION_NAME)
                        .doc(FirebaseFireStoreData.SECOND_DOCUMENT_NAME)
                        .update({
                      FirebaseFireStoreData.SECOND_DOCUMENT_SECOND_ID_NAME:
                          FirebaseFireStoreData
                              .SECOND_DOCUMENT_UPDATED_SECOND_VALUE
                    });
                  },
                  //////wndifjnewjfnjwkenjkfwnekjfnkejw
                  child: Text(
                    "Update data in firebase",
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 20),
                  )),
              // Delete some specific document from the collection
              ElevatedButton(
                  onPressed: () async {
                    await firebaseFirestore
                        .collection(FirebaseFireStoreData.COLLECTION_NAME)
                        .doc(FirebaseFireStoreData.DOCUMENT_NAME)
                        .delete();
                  },
                  child: Text(
                    "Delete data from firebase",
                    style: TextStyle(color: Colors.yellow, fontSize: 20),
                  )),

              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return UploadImageScreen();
                      },
                    ));
                  },
                  child: Text(
                    "Go to Image Uploaded Screen",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ))
            ],
          ),
        ));
  }
}
