import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222f3e),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              'kodebagus',
              style: TextStyle(color: Color(0xffc8d6e5), fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              'Cats and Dogs Detector App',
              style: TextStyle(
                  color: Color(0xffc8d6e5),
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            ),
            SizedBox(height: 15),
            Center(
              child: _loading
                  ? Container(
                      width: 350,
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/cat_dog_icon.png'),
                          SizedBox(height: 50)
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                image: FileImage(_image)),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                          ),
                          SizedBox(height: 20),
                          _output != null
                              ? Text(
                                  '${_output[0]['label']}',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                )
                              : Container(),
                          SizedBox(height: 25)
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 200,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Capture a Photo',
                        style: TextStyle(
                            color: Color(0xff222f3e),
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      pickGalleryImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 200,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Select Images',
                        style: TextStyle(
                            color: Color(0xff222f3e),
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
