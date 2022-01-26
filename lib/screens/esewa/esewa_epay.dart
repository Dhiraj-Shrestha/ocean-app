// import 'package:esewa_flutter_sdk/esewa_config.dart';
// import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
// import 'package:esewa_flutter_sdk/esewa_payment.dart';
// import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class EsewaEpay extends StatefulWidget {
//   final int totalAmount;
//   // ignore: prefer_const_constructors_in_immutables
//   EsewaEpay({Key key, this.totalAmount}) : super(key: key);

//   @override
//   _TestPageState createState() => _TestPageState();
// }

// class _TestPageState extends State<EsewaEpay> {
//   // final Completer<WebViewController> _controller = Completer<WebViewController>();

//   // WebViewController _webViewController;

//   // String testUrl = "https://pub.dev/packages/webview_flutter";

//   // _loadHTMLfromAsset() async {
//   //   String file = await rootBundle.loadString("assets/epay_request.html");
//   //   _webViewController.loadUrl(Uri.dataFromString(file,
//   //           mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//   //       .toString());
//   // }

//   // // ePay deatils
//   // double txAmt = 0;
//   // double psc = 0;
//   // double pdc = 0;
//   // String scd = "EPAYTEST";
//   // String su = "https://github.com/sarojghising";
//   // String fu = "https://refactoring.guru/design-patterns/factory-method";

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Enable hybrid composition.
//   //   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   // }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     // floatingActionButton: FloatingActionButton(
//   //     //   onPressed: () {
//   //     //     setState(() {
//   //     //       String pid = UniqueKey().toString();
//   //     //       _webViewController.evaluateJavascript(
//   //     //           'requestPayment(tAmt = $tAmt, amt = $amt, txAmt = $txAmt, psc = $psc, pdc = $pdc, scd = "$scd", pid = "$pid", su = "$su", fu = "$fu")');
//   //     //     });
//   //     //   },
//   //     //   child: Icon(Icons.add),
//   //     // ),
//   //     appBar: AppBar(
//   //       backgroundColor: appPrimaryColor,
//   //       elevation: 0,
//   //       leading: IconButton(
//   //         icon: SvgPicture.asset(
//   //           'assets/images/back.svg',
//   //           color: Colors.white,
//   //         ),
//   //         onPressed: () => Navigator.pop(context),
//   //       ),
//   //     ),
//   //     body: WebView(
//   //       initialUrl: "about:blank",
//   //       javascriptMode: JavascriptMode.unrestricted,
//   //       // ignore: prefer_collection_literals
//   //       javascriptChannels: Set.from([
//   //         JavascriptChannel(
//   //           name: "message",
//   //           onMessageReceived: (message) {},
//   //         ),
//   //       ]),
//   //       onPageFinished: (data) {
//   //         setState(() {
//   //           String pid = UniqueKey().toString();
//   //           double tAmt = widget.amount.toDouble();
//   //           double amt = widget.amount.toDouble();
//   //           // ignore: deprecated_member_use
//   //           _webViewController.evaluateJavascript(
//   //               'requestPayment(tAmt = $tAmt, amt = $amt, txAmt = $txAmt, psc = $psc, pdc = $pdc, scd = "$scd", pid = "$pid", su = "$su", fu = "$fu")');
//   //         });
//   //       },
//   //       onWebViewCreated: (webViewController) {
//   //         // _controller.complete(webViewController);
//   //         _webViewController = webViewController;
//   //         _loadHTMLfromAsset();
//   //       },
//   //     ),
//   //   );
//   // }

//   // EsewaPayment _esewaPnp;
//   // EsewaConfig _configuration;

//   Future<void> payment() async {
//     return EsewaFlutterSdk.initPayment(
//       esewaConfig: EsewaConfig(
//         environment: Environment.test,
//         clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
//         secretId: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
//       ),
//       esewaPayment: EsewaPayment(
//         productId: "1d71jd81",
//         productName: "Product One",
//         productPrice: "20",
//         callbackUrl: "www.test-url.com",
//       ),
//       onPaymentSuccess: (EsewaPaymentSuccessResult data) {
//         debugPrint(":::SUCCESS::: => $data");
//       },
//       onPaymentFailure: (data) {
//         debugPrint(":::FAILURE::: => $data");
//       },
//       onPaymentCancellation: (data) {
//         debugPrint(":::CANCELLATION::: => $data");
//       },
//     );
//   }

//   // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   double _amount = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // key: _scaffoldKey,

//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 setState(() {
//                   _amount = double.parse(value);
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: "Enter amount",
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             TextButton(
//                 onPressed: () {
//                   payment();
//                 },
//                 child: Text('cc')),
//             SizedBox(
//               height: 84,
//             ),
//             Text(
//               "Plugin developed by Ashim Upadhaya.",
//               style: TextStyle(color: Colors.black45),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
