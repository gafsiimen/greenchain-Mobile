
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String message = "";

  @override
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Scan Barcode'),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new RaisedButton(
                      onPressed: barcodeScanning, child: new Text("Capture image")),
                  padding: const EdgeInsets.all(8.0),
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                new Text("Barcode Number after Scan : " + message),
             
              ],
            ),
          )),
    );
  }
bool _isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

// Method for scanning barcode....
  Future barcodeScanning() async {

    try {
      String barcode = await BarcodeScanner.scan();
      if ((barcode.length==13) && (_isNumeric(barcode)))
      setState(() => this.message = barcode); 
      else 
      setState(() => this.message = 'Invalid barcode content');
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.message = 'No camera permission!';
        });
      } else {
        setState(() => this.message = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.message =
          'Nothing captured.');
    } catch (e) {
      setState(() => this.message = 'Unknown error: $e');
    }
  }
}