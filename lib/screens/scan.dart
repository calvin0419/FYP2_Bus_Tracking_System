import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
/*import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  List<String> scanHistory = [];

  @override
  void initState() {
    super.initState();
    _loadScanHistory();
  }

  // Load scan history from SharedPreferences
  void _loadScanHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      scanHistory = prefs.getStringList('scanHistory') ?? [];
    });
  }

  // Save scan history to SharedPreferences
  void _saveScanHistory(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scanHistory.add(code);
    await prefs.setStringList('scanHistory', scanHistory);
  }

  // Scan QR code from uploaded photo
  void _scanPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Here, you would add code to process the image and extract a QR code.
      // Packages like `qr_code_tools` can help, though it might require platform-specific code.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Feature under development")),
      );
    }
  }

  // Manual input dialog
  void _showManualInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String manualInput = '';
        return AlertDialog(
          title: Text('Enter QR Code Data'),
          content: TextField(
            onChanged: (value) => manualInput = value,
            decoration: InputDecoration(hintText: "Enter code"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (manualInput.isNotEmpty) {
                  setState(() {
                    scanHistory.add(manualInput);
                  });
                  _saveScanHistory(manualInput);
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: Column(
        children: [
          // QR Code Scanner
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          // Control Panel
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _scanPhoto,
                      child: Text('Upload Photo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isFlashOn = !isFlashOn;
                          controller?.toggleFlash();
                        });
                      },
                      child: Text(isFlashOn ? 'Flash Off' : 'Flash On'),
                    ),
                    ElevatedButton(
                      onPressed: _showManualInputDialog,
                      child: Text('Manual Input'),
                    ),
                  ],
                ),
                // Display Scan History
                Expanded(
                  child: ListView.builder(
                    itemCount: scanHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(scanHistory[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanHistory.add(scanData.code!);
      });
      _saveScanHistory(scanData.code!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scanned: ${scanData.code}')),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
*/
class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Screen"),
      ),
      body: Center(
        child: Text(
          'This is the Scan Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}