import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MyQRCodeScanPage extends StatefulWidget {
  const MyQRCodeScanPage({super.key});

  @override
  State<MyQRCodeScanPage> createState() => _MyQRCodeScanPageState();
}

class _MyQRCodeScanPageState extends State<MyQRCodeScanPage> {
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
        if (scannedQRCode != '-1') {
          Get.snackbar(
              'QRCode Scanner Result', 'Scanned QRCode: $scannedQRCode',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.lightBlue,
              colorText: Colors.white);
        } else {
          Get.snackbar('QRCode Scanner Result', 'No Data Fetched',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.lightBlue,
              colorText: Colors.white);
        }
      });
    });
  }

  void _scanQRCode() async {
    try {
      scannedQRCode = await FlutterBarcodeScanner.scanBarcode(
          '#FF6666', 'Cancel', true, ScanMode.QR);
      if (scannedQRCode != '-1') {
        Get.snackbar('Barcode Scan Result', 'Scanned QRCode: $scannedQRCode',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.lightBlue,
            colorText: Colors.white);
      } else {
        Get.snackbar('QRCode Scanner Result', 'No Data Fetched',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.lightBlue,
            colorText: Colors.white);
      }
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(thickness: 1, color: Colors.grey),
            const Text(
              'QR Code Scanner:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
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
            const Divider(thickness: 1, color: Colors.grey),
            const Text(
              'QR Code Scanner2:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
              onPressed: _scanQRCode,
              child: const Text(
                'Use Barcode Scanner',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
