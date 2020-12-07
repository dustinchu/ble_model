import 'package:bl_model/screen/bluetooth_device/bluetooth_device_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothProviderState extends ChangeNotifier {
  bool connectBluetoothState = false;
  bool timeout = false;

  void blueConnect(ScanResult result, BuildContext context) async {
    timeout = false;
    print(result.device.name);
    connectBluetoothState = true;
    notifyListeners();
    print(connectBluetoothState);
    await result.device.connect().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        timeout = true;
        print("timeout");
      },
    );
    connectBluetoothState = false;
    notifyListeners();
    if (!timeout) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BluetoothDeviceScreen(result: result)));
    }
  }
}
