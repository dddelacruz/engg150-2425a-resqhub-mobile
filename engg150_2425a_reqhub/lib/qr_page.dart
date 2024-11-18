import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScanner extends StatefulWidget{
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRViewExampleState();
}

class _QRScannerState extends State<QRScanner>{
  @override
  Widget build(BuildContext context){
    return Icon(Icons.qr_code);
  }
}

class _QRViewExampleState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final db = FirebaseFirestore.instance;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // handler if text is scanned
                  if (result != null)
                    const Text('Scan a code')
                    //Text(
                    //    'Barcode Type: ${result!.format.name}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${snapshot.data!.name}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void  _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if(result != null){
        log("data has been read");

        String str = result!.code!;
        var qrData = jsonDecode(str) as Map<String, dynamic>;
        log(str);

        if(qrData["subject"] != null){
          controller.pauseCamera().then((_){
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              confirmBtnText: 'Yes',
              cancelBtnText: 'No',
              text: "Create/Update log?\nPCN: ${qrData["subject"]["PCN"]}",
              onConfirmBtnTap: () async {
                var loggingOut = false;
                log("adding log to database");

                // check if unlogged out log is in database
                db.collection("logs").where("id", isEqualTo: qrData["subject"]["PCN"]).get().then((querySnapshot){
                  for (var docSnapshot in querySnapshot.docs) {
                    log('${docSnapshot.id} => ${docSnapshot.data()}');
                    if(docSnapshot.data()['timeOut'] == null){
                      log("logging out");
                      loggingOut = true;

                      db.collection("logs").doc(docSnapshot.id).set({"timeOut" : DateTime.now()}, SetOptions(merge: true));

                      break;
                    }
                  }


                  // user is logging in
                  if(!loggingOut){
                    log("logging in");
                    // add to firebase
                    final newlog = <String, dynamic>{
                      "id": qrData["subject"]["PCN"],
                      "timeIn": DateTime.now(),
                      "timeOut": null,
                    };

                    db.collection("logs").add(newlog).then((DocumentReference doc) =>
                      log('DocumentSnapshot added with ID: ${doc.id}'));

                    // check if user exists in db
                    db.collection("users").doc(qrData["subject"]["PCN"]).get().then((doc){
                      // user is not in database, add to database
                      if (!doc.exists){
                        log("adding user to database");
                        db.collection("users").doc(qrData["subject"]["PCN"]).set(qrData["subject"]);
                      }
                      else{
                        log("user already in database");
                      }
                    });

                    Navigator.pop(context);


                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "User was logged in",
                    );

                  }
                  else{
                    Navigator.pop(context);


                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: "User was logged out",
                    );
                  }
                });

                await controller.resumeCamera();
              },
              onCancelBtnTap: () async {
                Navigator.pop(context);
                await controller.resumeCamera();
              }
            );
          });
          //controller.resumeCamera();
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}