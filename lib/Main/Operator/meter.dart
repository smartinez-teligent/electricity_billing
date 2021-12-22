import 'package:flutter/material.dart';

class Meter extends StatefulWidget {
  final String userID, customerID, meterID, consumption;
  const Meter(
      {Key? key,
      required this.userID,
      required this.customerID,
      required this.meterID,
      required this.consumption})
      : super(key: key);

  @override
  _MeterState createState() => _MeterState();
}

class _MeterState extends State<Meter> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Meter Information and Consumption",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("1", style: TextStyle(fontSize: 16)),
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
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("1234", style: TextStyle(fontSize: 16)),
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
                      child: Text("Date:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("2021-11-01", style: TextStyle(fontSize: 16)),
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
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("1000", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
