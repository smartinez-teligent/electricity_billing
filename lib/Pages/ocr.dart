import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';
// import 'package:image/image.dart' as im;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';

import '../Main/Operator/dashboard.dart';

class OCR extends StatefulWidget {
  final String customerid, meterid, consumption;
  const OCR(
      {Key? key,
      required this.customerid,
      required this.meterid,
      required this.consumption})
      : super(key: key);

  @override
  _OCRState createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  bool _scanning = false;
  String _extractText = '';
  XFile? _pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Read Meter Consumption'),
      ),
      body: ListView(
        children: [
          _pickedImage == null
              ? Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 100,
                  ),
                )
              : Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: FileImage(File(_pickedImage!.path)),
                        fit: BoxFit.fill,
                      )),
                ),
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Upload Image of meter consumption',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                setState(() {
                  _scanning = true;
                });
                final ImagePicker _picker = ImagePicker();
                _pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
                print(_pickedImage!.path);
                _extractText = await FlutterTesseractOcr.extractText(
                    _pickedImage!.path,
                    language: 'eng');
                setState(() {
                  _scanning = false;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          _scanning
              ? Center(child: CircularProgressIndicator())
              : Icon(
                  Icons.done,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _extractText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OperatorDashboard(
                        customerid: widget.customerid,
                        meterid: widget.meterid,
                        consumption: _extractText,
                      )));
        },
        label: const Text('Done'),
        icon: const Icon(Icons.app_registration),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
