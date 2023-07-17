import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_youtube/screens/fetch_image.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

bool isLoading = false;

class _UploadImageScreenState extends State<UploadImageScreen> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static const CAMERA_SELECTED = "camera_selected";
  static const GALLERY_SELECTED = "gallery_selected";

  Future<void> uploadImage(String inputSource) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: inputSource == CAMERA_SELECTED
            ? ImageSource.camera
            : ImageSource.gallery);

    if (pickedImage == null) {
      return null;
    }

    String fileName = pickedImage.name;
    File imageFile = File(pickedImage.path);

    try {
      setState(() {
        isLoading = true;
      });

      //  Firebase code to add the image to the firebase fire store
      await firebaseStorage.ref(fileName).putFile(imageFile);
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image Uploaded Successfully")));
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uplaod Image Screen"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      uploadImage(_UploadImageScreenState.CAMERA_SELECTED);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text("Camera"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      uploadImage(_UploadImageScreenState.GALLERY_SELECTED);
                    },
                    icon: Icon(Icons.photo_camera_back_outlined),
                    label: Text("Gallery"),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return FetchImage();
                          },
                        ));
                      },
                      child: Text("Go to fetch image screen"))
                ],
              ),
      ),
    );
  }
}
