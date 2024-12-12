import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class QRCodeScanScreen extends StatefulWidget {
  @override
  _QRCodeScanScreenState createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    // Any initialization if needed
  }

  void _onQRViewCreated(Result result) {
    if (!_hasScanned) {
      setState(() {
        _hasScanned = true; // Ensure the data is shown only once
      });
      _showPopup(result.text);
    }
  }

  void _showPopup(String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'QR Code Data',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          content: Text(
            qrData,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Scan Lagi',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  _hasScanned = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Kembali',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code Scanner',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRCodeDartScanView(
              scanInvertedQRCode: true,
              onCapture: (Result result) {
                _onQRViewCreated(result);
              },
            ),
          ),
        ],
      ),
    );
  }
}
