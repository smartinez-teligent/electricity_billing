import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../Class/notificationClass.dart';
import '../../Class/operatorClass.dart';
import '../../Pages/ocr.dart';
import '../../Pages/qrcode.dart';
import '../login.dart';

class OperatorDashboard extends StatefulWidget {
  final String customerid, meterid, consumption;
  const OperatorDashboard(
      {Key? key,
      required this.customerid,
      required this.meterid,
      required this.consumption})
      : super(key: key);

  @override
  _OperatorDashboardState createState() => _OperatorDashboardState();
}

class _OperatorDashboardState extends State<OperatorDashboard> {
  String userID = "619ba680bdfc9849ba8db413",
      customerID = "",
      meterID = "",
      consumption = "";
  var con;

  @override
  void initState() {
    super.initState();
    setState(() {
      customerID = widget.customerid;
      meterID = widget.meterid;
      consumption = widget.consumption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Operator Dashboard"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              })
        ],
      ),
      body: LoaderOverlay(
        child: Column(
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: SizedBox.fromSize(
                      size: Size(
                          MediaQuery.of(context).size.width * 0.4,
                          MediaQuery.of(context).size.width *
                              0.4), // button width and height
                      child: ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // button color
                          child: InkWell(
                            splashColor: Colors.blue, // Splash color
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QRCode(
                                          customerid: customerID,
                                          meterid: meterID,
                                          consumption: consumption)));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.qr_code_2,
                                    size: 60, color: Colors.black),
                                AutoSizeText(
                                  'Scan Meter\nInformation',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                // Text("Scan Meter\nInformation",
                                //     style: TextStyle(fontWeight: FontWeight.bold),
                                //     textAlign: TextAlign.center), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(width: 20),
                    Center(
                        child: SizedBox.fromSize(
                      size: Size(
                          MediaQuery.of(context).size.width * 0.4,
                          MediaQuery.of(context).size.width *
                              0.4), // button width and height
                      child: ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // button color
                          child: InkWell(
                            splashColor: Colors.blue, // Splash color
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OCR(
                                          customerid: customerID,
                                          meterid: meterID,
                                          consumption: consumption)));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/meter2.png',
                                    height: 60, fit: BoxFit.fill),
                                SizedBox(height: 10),
                                AutoSizeText(
                                  'Read Meter\nConsumption',
                                  minFontSize: 10,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ), // icon
                                // Text("Read Meter\nConsumption",
                                //     style: TextStyle(fontWeight: FontWeight.bold),
                                //     textAlign: TextAlign.center), // text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            Container(
                child: Material(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Meter Information and Consumption",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                color: Colors.white,
                                width: 3.0,
                              )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Operator ID:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(userID, style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    color: Colors.grey.shade200,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                color: Colors.white,
                                width: 3.0,
                              )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Customer ID:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(customerID,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    color: Colors.grey.shade200,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                color: Colors.white,
                                width: 3.0,
                              )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Meter ID:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text(meterID, style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    color: Colors.grey.shade200,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                color: Colors.white,
                                width: 3.0,
                              )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Consumption:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(consumption,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (customerID == "") {
            final snackBar = SnackBar(
              content: const Text('Scan the meter information'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (consumption == "") {
            final snackBar = SnackBar(
              content: const Text('Read the meter consumption'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            context.loaderOverlay.show();
            oprt(userID, widget.customerid, widget.meterid,
                    widget.consumption.replaceAll("KwH", ""))
                .then((value) {
              setState(() {
                customerID = "";
                meterID = "";
                consumption = "";
              });
              // print("customertoken: ${value.toString()}");
              notification(value.toString()).then((notif) {
                print("notification: ${notif.toString()}");
                context.loaderOverlay.hide();
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: const Text('Submit meter successful'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            });
          }
        },
        label: const Text('Submit Reader'),
        icon: const Icon(Icons.app_registration),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
