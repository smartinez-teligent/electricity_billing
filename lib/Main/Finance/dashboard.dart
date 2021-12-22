import 'dart:io';
import 'dart:math';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import '../../Class/customerClass.dart';
import '../../Class/financeClass.dart';
import '../login.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({Key? key}) : super(key: key);

  @override
  _FinanceDashboardState createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Finance Dashboard"),
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
      body: FutureBuilder(
        future: getAllCustomer(),
        builder: (context, AsyncSnapshot<dynamic> snapShot) {
          if (snapShot.data == null ||
              snapShot.connectionState == ConnectionState.waiting ||
              snapShot.hasError) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            print("test");
            return Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 30),
                    child: DataTable(
                      showCheckboxColumn: false,
                      // sortAscending: sort,
                      sortColumnIndex: 0,
                      columns: [
                        DataColumn(
                          label: Text("Customer ID",
                              style: TextStyle(fontSize: 16)),
                          numeric: false,
                        ),
                        DataColumn(
                          label:
                              Text("Meter IDs", style: TextStyle(fontSize: 16)),
                          numeric: false,
                        ),
                      ],
                      rows: snapShot.data
                          .map<DataRow>(
                            (data) => DataRow(
                                onSelectChanged: (selected) {
                                  showSimpleCustomDialog(
                                      context,
                                      data["meterids"],
                                      data["customerid"].toString());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             DtrManual(dtrList: data)));
                                },
                                // selected: selectedProducts.contains(product),
                                cells: [
                                  DataCell(
                                    Text(data["customerid"].toString()),
                                  ),
                                  DataCell(
                                    Text(data["meterids"].toString()),
                                  ),
                                ]),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            );

            // DataTable(
            //   columnSpacing: 35.0,
            //   showCheckboxColumn: false,
            //   columns: <DataColumn>[
            //     DataColumn(
            //       label: Text('Customer ID'),
            //     ),
            //     DataColumn(
            //       label: Text('Meter ID'),
            //     ),
            //   ],
            //   rows: snapShot.data
            //       .map<DataRow>(
            //         (data) => DataRow(
            //           // onSelectChanged: (selected) {
            //           //   Navigator.push(
            //           //       context,
            //           //       MaterialPageRoute(builder: (context) => DtrManual(dtrList: data)));
            //           // },
            //           cells: [
            //             DataCell(
            //               Text('${data["customerid"].toString()}'),
            //             ),
            //             DataCell(
            //               Text(data["meterids"].toString()),
            //             )
            //           ],
            //         ),
            //       )
            //       .toList(),
            // ),

          }
        },
      ),
    );
  }
}

void showSimpleCustomDialog(
    BuildContext context, List<dynamic> dt, String customerID) {
  final dateFormat = DateFormat("yyyy-MM-dd");
  TextEditingController _readingCtl = new TextEditingController();
  TextEditingController _dueCtl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = dt[0].toString();
  String? reading, dueDate = "", amountdue = "", id = "";
  getCustomerBills(customerID).then((val) {
    var bills = val;
    var bill = val.where((c) => c['meterid'] == dt[0].toString()).toList();
    if (bill.length != 0) {
      _readingCtl.text = bill[0]['reading'].toString();
      _dueCtl.text = dateFormat
          .format(DateTime.parse(bill[0]['duedate'].toString()))
          .toString();
      id = bill[0]['_id'].toString();
      reading = bill[0]['reading'].toString();
      dueDate = bill[0]['duedate'].toString();
      amountdue = bill[0]['amountdue'].toString();
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Container(
          color: Colors.blue,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Customer Bills",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            onPressed: () {
              updateCustomerBill(id!, reading!, dueDate!).then((value) {
                print(value);
                _readingCtl.text = value['reading'].toString();
                _dueCtl.text = dateFormat
                    .format(DateTime.parse(value['duedate'].toString()))
                    .toString();
                id = value['_id'].toString();
                reading = value['reading'].toString();
                dueDate = value['duedate'].toString();
                amountdue = value['amountdue'].toString();
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: const Text('Update Successful'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPage()));
            },
            child: Text(
              'Update',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPage()));
            },
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          )
        ],
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              height: 300.0,
              width: 300.0,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Customer ID: ',
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                '${customerID.toString()}',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Meter ID: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text('Enter value'),
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  // This set state is trowing an error
                                  setState(() {
                                    dropdownValue = newValue!;
                                    bill = val
                                        .where((c) => c['meterid'] == newValue)
                                        .toList();
                                    print(bill);
                                    if (bill.length != 0) {
                                      _readingCtl.text =
                                          bill[0]['reading'].toString();
                                      _dueCtl.text = dateFormat
                                          .format(DateTime.parse(
                                              bill[0]['duedate'].toString()))
                                          .toString();
                                      id = bill[0]['_id'].toString();
                                      reading = bill[0]['reading'].toString();
                                      dueDate = bill[0]['duedate'].toString();
                                      amountdue =
                                          bill[0]['amountdue'].toString();
                                    } else {
                                      _readingCtl.text = "";
                                      _dueCtl.text = "";
                                      reading = "";
                                      dueDate = "";
                                      amountdue = "";
                                    }
                                  });
                                },
                                items: dt.map((value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,
                                        style:
                                            new TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Amount Due: ',
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                amountdue.toString() != ""
                                    ? '₱${amountdue.toString()}'
                                    : "₱0.00",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Reading:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  height: 30,
                                  child: TextFormField(
                                      controller: _readingCtl,
                                      // initialValue: reading,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please input Reading';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Input Reading',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      onChanged: (rd) => setState(() {
                                            reading = rd.toString();
                                          })),
                                )),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Due Date:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    child: DateTimeField(
                                      resetIcon: null,
                                      controller: _dueCtl,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Please input Date';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: "Date",
                                          border: OutlineInputBorder()),
                                      format: dateFormat,
                                      onShowPicker: (context, currentValue) {
                                        return showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));
                                      },
                                      onSaved: (date) => setState(() {
                                        dueDate = date.toString();
                                      }),
                                      onChanged: (date) => setState(() {
                                        dueDate = date.toString();
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ])),
                ],
              ),
            ),
          );
        }),
      ),
    );
  });

  // AlertDialog simpleDialog1 = AlertDialog(
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //   title: Container(
  //     color: Colors.blue,
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Text(
  //           "Customer Bills",
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     ),
  //   ),
  //   titlePadding: const EdgeInsets.all(0),
  //   content:
  //       StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
  //     return Container(
  //       height: 300.0,
  //       width: 300.0,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Padding(
  //               padding:
  //                   EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 10),
  //               child: Row(
  //                 children: <Widget>[
  //                   Expanded(
  //                     child: Text(
  //                       'Item',
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     width: 2,
  //                   ),
  //                   Container(
  //                     child: DropdownButton<String>(
  //                       hint: Text('Enter value'),
  //                       value: dropdownValue,
  //                       onChanged: (String? newValue) {
  //                         // This set state is trowing an error
  //                         setState(() {
  //                           dropdownValue = newValue!;
  //                         });
  //                       },
  //                       items: <String>[
  //                         'Fertilizers',
  //                         'Bags',
  //                         'Spray',
  //                         'Equipments'
  //                       ].map<DropdownMenuItem<String>>((String value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value,
  //                           child: new Text(value),
  //                         );
  //                       }).toList(),
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //           Padding(
  //               padding:
  //                   EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 10),
  //               child: Row(
  //                 children: <Widget>[
  //                   Expanded(
  //                     child: Text(
  //                       'Quantity',
  //                       style: TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     width: 2,
  //                   ),
  //                   Expanded(
  //                       child: TextField(
  //                     keyboardType: TextInputType.number,
  //                     decoration: InputDecoration(
  //                         labelText: 'Quantity',
  //                         hintText: 'Enter Cost Quantity',
  //                         border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(5.0))),
  //                   )),
  //                 ],
  //               )),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: <Widget>[
  //                 RaisedButton(
  //                   color: Colors.blue,
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text(
  //                     'Add',
  //                     style: TextStyle(fontSize: 18.0, color: Colors.white),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 RaisedButton(
  //                   color: Colors.red,
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockPage()));
  //                   },
  //                   child: Text(
  //                     'Cancel!',
  //                     style: TextStyle(fontSize: 18.0, color: Colors.white),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }),
  // );

  /* Dialog simpleDialog = Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child:
    ); */
  // showDialog(
  //     context: context, builder: (BuildContext context) => simpleDialog1);
}
