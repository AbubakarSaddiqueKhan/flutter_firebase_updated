import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FetchImage extends StatefulWidget {
  const FetchImage({super.key});

  @override
  State<FetchImage> createState() => _FetchImageState();
}

FirebaseStorage firebaseStorage = FirebaseStorage.instance;

class _FetchImageState extends State<FetchImage> {
  static const URL = "url";
  static const PATH = "path";

  Future<List> loadImages() async {
    List<Map> files = [];
    try {
      final ListResult result = await firebaseStorage.ref().listAll();
      final List<Reference> allFiles = result.items;
      await Future.forEach(allFiles, (Reference file) async {
        final String fileUrl = await file.getDownloadURL();
        files.add({URL: fileUrl, PATH: file.fullPath});
      });
    } catch (e) {
      print(e);
    }
    print(files);
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Image from firestore"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: loadImages(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final Map image = snapshot.data[index];
                    return SizedBox(
                      height: 200,
                      width: 200,
                      //  cached network image is the package that can show a place holder image when the image is loading
                      //  it will also used to store the fetched image in the local storage then it will not download it again and fetch from firebase again
                      child: Image.network(
                        image[URL],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

Future<void> deleteImage(String ref) async {
  await firebaseStorage.ref(ref).delete();
}
