import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_idv/flutter_idv.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

class _MyAppState extends State<MyApp> {
  var faceSdk = IDV.instance;

  var _status = "nil";
  set status(String val) => setState(() => _status = val);
  
  void init() async {
    super.initState();
    if (!await initialize()) return;
    status = "Ready";
  }

  Future<bool> initialize() async {
    status = "Initializing...";
    // var license = await loadAssetIfExists("assets/regula.license");
    // InitConfig? config = null;
    // if (license != null) config = InitConfig(license);
    // var (success, error) = await faceSdk.initialize(config: config);
    // if (!success) {
    //   status = error!.message;
    //   print("${error.code}: ${error.message}");
    // }
    return true;
  }

  Future<ByteData?> loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  Widget useGallery(int number) {
    return textButton("Use gallery", () async {
      Navigator.pop(context);
      // var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (image != null) {
      //   setImage(File(image.path).readAsBytesSync(), ImageType.PRINTED, number);
      // }
    });
  }

  Widget useCamera(int number) {
    return textButton("Use camera", () async {
      Navigator.pop(context);
      // var response = await faceSdk.startFaceCapture();
      // var image = response.image;
      // if (image != null) setImage(image.image, image.imageType, number);
    });
  }

  Widget image(Image image, Function() onTap) => GestureDetector(
        onTap: onTap,
        child: Image(height: 150, width: 150, image: image.image),
      );

  Widget button(String text, Function() onPressed) {
    return Container(
      child: textButton(
        text,
        onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.black12),
        ),
      ),
      width: 250,
    );
  }

  Widget text(String text) => Text(text, style: TextStyle(fontSize: 18));
  Widget textButton(String text, Function() onPressed, {ButtonStyle? style}) =>
      TextButton(child: Text(text), onPressed: onPressed, style: style);

  setImageDialog(BuildContext context, int number) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Select option"),
          actions: [useGallery(number), useCamera(number)],
        ),
      );

  @override
  Widget build(BuildContext bc) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(_status))),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(bc).size.height / 8),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    init();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
