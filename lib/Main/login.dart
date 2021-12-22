import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import '../Class/loginClass.dart';
import 'Customer/dashboard.dart';
import 'Finance/dashboard.dart';
import 'Operator/dashboard.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:telitime/Class/errorClass.dart';
// import 'package:telitime/Class/loginClass.dart';
// import 'package:telitime/Main/dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  String _password = "12345", _emailAddress = "customer-one@gmail.com";

  bool _isBusy = false;
  final String _clientId = 'l5fwK6ckuSu1zEcMStD4gK13G7ca';
  final String _redirectUrl = 'wso2sample://oauth2';
  final String _issuer = 'http://3e54-202-164-172-203.ngrok.io';
  final String _discoveryUrl =
      'https://3e54-202-164-172-203.ngrok.io/oauth2/oidcdiscovery/.well-known/openid-configuration';
  final String _postLogoutRedirectUrl = 'io.identityserver.demo:/';
  final List<String> _scopes = <String>['openid', 'profile'];
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
          authorizationEndpoint:
              'http://3e54-202-164-172-203.ngrok.io/oauth2/authorize',
          tokenEndpoint: 'http://3e54-202-164-172-203.ngrok.io/oauth2/token');
  Future<void> _signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_clientId, _redirectUrl,
            serviceConfiguration: _serviceConfiguration,
            scopes: _scopes,
            preferEphemeralSession: preferEphemeralSession),
      );
      print("=============================");
      print(result);

      // if (result != null) {
      //   _processAuthTokenResponse(result);
      //   await _testApi(result);
      // }
    } catch (_) {
      print(_);
      _clearBusyState();
    }
  }

  Future<void> _signInWithNoCodeExchange() async {
    try {
      _setBusyState();
      // use the discovery endpoint to find the configuration
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(_clientId, _redirectUrl,
            discoveryUrl: _discoveryUrl, scopes: _scopes),
      );
      print("=============================");
      print(result);
      // if (result != null) {
      //   _processAuthResponse(result);
      // }
    } catch (_) {
      _clearBusyState();
    }
  }

  void _setBusyState() {
    setState(() {
      _isBusy = true;
    });
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF3366FF),
                                        const Color(0xFF00CCFF),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.0, 2.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(0.0, 1.5),
                                      blurRadius: 1.5,
                                    ),
                                  ]),
                            ),
                            alignment: Alignment.center,
                          ),
                          // ignore: unnecessary_null_comparison
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          // ..._nameController != null ? _registerLogo : _loginLogo
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: "Email address",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                              validator: (value) {
                                if (value == "") {
                                  return "Input email address";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _emailAddress = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              obscureText: _isHidden,
                              onEditingComplete: () => node.nextFocus(),
                              validator: (value) {
                                if (value == "") {
                                  return 'Input password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                suffix: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _password = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              // width: width,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Theme.of(context).primaryColor,
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.0, 1.0),
                                      stops: [0.0, .5],
                                      tileMode: TileMode.clamp),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(0.0, .5),
                                      blurRadius: .5,
                                    ),
                                  ]),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        await loginAuth(
                                                _emailAddress, _password)
                                            .then((result) {
                                          print(result);
                                          if (result != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => result[
                                                                'usertype'] ==
                                                            1
                                                        ? LoaderOverlay(
                                                            child: Dashboard(
                                                            cusID: result['id'],
                                                          ))
                                                        : result['usertype'] ==
                                                                2
                                                            ? OperatorDashboard(
                                                                consumption: '',
                                                                customerid: '',
                                                                meterid: '')
                                                            : FinanceDashboard()));
                                          } else {
                                            print("error");
                                            final snackBar = SnackBar(
                                              backgroundColor: Colors.red,
                                              content: const Text(
                                                  'Invalid Email or Password'),
                                              action: SnackBarAction(
                                                label: 'OK',
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            // displayError(context, result['login']['errors'][0]['message'].toString(), result['login']['errors'][0]['field'].toString());
                                          }
                                        });
                                      }
                                    },
                                    child: Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        padding: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Icon(Icons.timer,
                                            //     size: 30, color: Theme.of(context).primaryColor,),
                                            Text(
                                              '  LOGIN',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     _signInWithAutoCodeExchange();
                          //   },
                          //   child: Ink(
                          //     color: Colors.blue,
                          //     child: Padding(
                          //       padding: EdgeInsets.all(6),
                          //       child: Wrap(
                          //         crossAxisAlignment: WrapCrossAlignment.center,
                          //         children: [
                          //           Image.asset('assets/wso2.png',
                          //               height: 30,
                          //               fit: BoxFit
                          //                   .fill), // <-- Use 'Image.asset(...)' here
                          //           SizedBox(width: 12),
                          //           Text('Sign in with WSO2'),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
