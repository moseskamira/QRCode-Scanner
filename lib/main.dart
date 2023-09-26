import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'QR Code Scanner Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String scannedQRCode = '';
  late Barcode barcodeResult;
  QRViewController? qrViewController;

  void _onQRViewCreated(QRViewController qRViewController) {
    setState(() => qrViewController = qRViewController);
    qrViewController?.resumeCamera();
    qrViewController?.scannedDataStream.listen((scannedData) {
      setState(() {
        barcodeResult = scannedData;
        if (barcodeResult.code != null) {
          scannedQRCode = barcodeResult.code!;
        }
        Get.snackbar('QRCode Scanner Result', 'Scanned QRCode: $scannedQRCode',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.lightBlue);
      });
    });
  }

  void _scanQRCode() async {
    try {
      scannedQRCode = await FlutterBarcodeScanner.scanBarcode(
          '#FF6666', 'Cancel', true, ScanMode.QR);
      Get.snackbar('Barcode Scan Result', 'Scanned QRCode: $scannedQRCode',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.lightBlue);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Below is QR Code Scanner:'),
            SizedBox(
              height: 300,
              width: Get.width * 0.70,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.lightBlue,
                  borderRadius: 12,
                  borderLength: 20,
                  borderWidth: 10,
                  cutOutSize: 250,
                  overlayColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
              onPressed: _scanQRCode,
              child: const Text(
                'Click To Use Barcode Scanner',
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
