import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../Class/customerClass.dart';
import 'otpVerification.dart';

class Information extends StatefulWidget {
  final String customerid,
      customername,
      amount,
      duedate,
      meterid,
      billid,
      paymentmethod;
  const Information(
      {Key? key,
      required this.customerid,
      required this.customername,
      required this.amount,
      required this.duedate,
      required this.meterid,
      required this.billid,
      required this.paymentmethod})
      : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  String billingID = "", amount = "", otp = "", paymentMethod = "";
  static const snackBarText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
                // width: width,
                height: 180.0,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 1.5),
                    blurRadius: 1.5,
                  ),
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(child: Text("Hi ${widget.customername}!")),
                    ),
                    Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ClipOval(
                            child: Material(
                                color: Colors.blue.shade100, // Button color
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.account_circle,
                                      size: 40, color: Colors.blue),
                                )),
                          ), // text
                        ],
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Column(children: <Widget>[
                      Text("Customer ID:",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "${widget.customerid}",
                        textAlign: TextAlign.center,
                      )
                    ]))),
                  ]),
                )),
          ),
          SizedBox(width: 30),
          Expanded(
            child: Container(
                // width: width,
                height: 180.0,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 1.5),
                    blurRadius: 1.5,
                  ),
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 120,
                          child: Column(
                            children: [
                              Expanded(
                                  child: Center(
                                      child: Column(children: <Widget>[
                                Text("₱${widget.amount}",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  paymentMethod != "" ||
                                          widget.paymentmethod != ""
                                      ? "(PAID)"
                                      : widget.amount == "0"
                                          ? ""
                                          : "(UNPAID)",
                                  textAlign: TextAlign.center,
                                )
                              ]))),
                              Expanded(
                                  child: Center(
                                      child: Column(children: <Widget>[
                                Text("Due Date:",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  widget.amount == "0"
                                      ? ""
                                      : "${widget.duedate}",
                                  textAlign: TextAlign.center,
                                )
                              ]))),
                              Expanded(
                                  child: Center(
                                      child: Column(children: <Widget>[
                                Text("Meter ID:",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  "${widget.meterid}",
                                  textAlign: TextAlign.center,
                                )
                              ]))),
                            ],
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: paymentMethod != "" ||
                                  widget.paymentmethod != "" ||
                                  widget.amount == "0"
                              ? null
                              : () {
                                  context.loaderOverlay.show();
                                  requestOTP().then((value) {
                                    context.loaderOverlay.hide();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoaderOverlay(
                                                    child: OTPVerification(
                                                  billid: widget.billid,
                                                  amount: widget.amount,
                                                  cusid: widget.customerid,
                                                ))));
                                    // final snackBar = SnackBar(
                                    //   elevation: 10,
                                    //   dismissDirection: DismissDirection.up,
                                    //   backgroundColor: Colors.green,
                                    //   content: Text("Check OTP in Telegram"),
                                    //   action: SnackBarAction(
                                    //     textColor: Colors.white,
                                    //     label: 'OK',
                                    //     onPressed: () {
                                    //       // Some code to undo the change.
                                    //     },
                                    //   ),
                                    // );
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    // context.loaderOverlay.hide();
                                    // _displayTextInputDialog(context);
                                  });
                                },
                          child: Text('Pay now'),
                        )
                      ]),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('OTP Verification'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  otp = value;
                });
              },
              decoration: InputDecoration(hintText: "Input OTP"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    print(widget.billid + " " + widget.amount);
                    payBills(widget.billid, widget.amount, otp).then((value) {
                      print("payment: ${value.toString()}");
                      // setState(() {
                      //   paymentMethod = value['paymentmethod'];
                      // });
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // Navigator.pop(context);
                    });
                    // codeDialog = valueText;
                    // Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
