import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../Class/customerClass.dart';
import '../../Class/pushNotificationClass.dart';
import '../login.dart';
import 'chart.dart';
import 'information.dart';

class Dashboard extends StatefulWidget {
  final String cusID;
  const Dashboard({Key? key, required this.cusID}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;
  late String token;
  String customerid = "",
      customername = "",
      amount = "",
      duedate = "",
      meterid = "",
      billid = "",
      paymentmethod = "";
  PushNotificationClass? _notificationInfo;
  final dateFormat = DateFormat("yyyy-MM-dd");

// FCM implementation
  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted the permission");
      FirebaseMessaging.instance.getToken().then((value) {
        getCustomer(customerid).then((cs) {
          // print("token: ${value.toString()}");
          // print("meter idsssss: ${cs.toString()}");
          updateCustomer(customerid, customerid, cs, value.toString())
              .then((data) {
            // print("data: ${data.toString()}");
            getCustomerBills(customerid).then((bills) {
              // print("bills: ${bills.toString()}");

              setState(() {
                // bool alreadyExist = bills[0].Contains("paymentmethod");
                if (bills[0].containsKey('paymentmethod')) {
                  paymentmethod = bills[0]['paymentmethod'];
                }
                print("paymeeeeeeeeeent: " + bills[0].toString());
                customername = bills[0]['customername'];
                amount = bills[0]['amountdue'];
                duedate = dateFormat
                    .format(DateTime.parse(bills[0]['duedate'].toString()));
                meterid = bills[0]['meterid'];
                billid = bills[0]['_id'];
                context.loaderOverlay.hide();
              });
            });
          });
        });
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotificationClass notification = PushNotificationClass(
            title: message.notification!.title,
            body: message.notification!.body,
            dataTitle: message.data['title'],
            dataBody: message.data['body']);
        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });

        if (notification != null) {
          _showNotification(notification.title, notification.body);
          print("notification receive");
        }
      });
    } else {
      print("Permission declined");
    }
  }

//local notification implementaion
  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _showNotification(title, body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'payment',
            channelDescription: 'payment notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      customerid = widget.cusID;
    });

    context.loaderOverlay.show();
    registerNotification();
    _totalNotificationCounter = 0;
    _requestPermissions();
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Customer Dashboard"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                  height: 180.0,
                  child: LoaderOverlay(
                    child: Information(
                        customerid: customerid,
                        customername: customername,
                        amount: amount,
                        duedate: duedate,
                        meterid: meterid,
                        billid: billid,
                        paymentmethod: paymentmethod),
                  )),
              SizedBox(height: 20),
              Container(height: 320.0, child: Chart()),
            ],
          ),
        ),
      ),
    );
  }
}
