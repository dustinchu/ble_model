import 'package:bl_model/widget/arrow_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

class BluetoothDeviceScreen extends StatelessWidget {
  final ScanResult result;
  const BluetoothDeviceScreen({Key key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController wifiNameController = TextEditingController();
    TextEditingController wifiPasswordController = TextEditingController();
    final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
    final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
    writeData(BluetoothCharacteristic targetCharacteristic, String data) async {
      if (targetCharacteristic != null) {
        List<int> bytes = utf8.encode(data);
        await targetCharacteristic.write(bytes);
      }
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            ArrowAppbar(
                onPressed: () {
                  if (result.device != null) {
                    result.device.disconnect();
                  }
                  Navigator.pop(context);
                },
                text: "null"),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: wifiNameController,
                decoration: InputDecoration(labelText: 'Wifi Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: wifiPasswordController,
                decoration: InputDecoration(labelText: 'Wifi Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: RaisedButton(
                onPressed: () async {
                  var wifiData =
                      '${wifiNameController.text},${wifiPasswordController.text}';

                  if (result.device != null) {
                    List<BluetoothService> services =
                        await result.device.discoverServices();
                    services.forEach((service) {
                      print("servie uuid ====${service.uuid.toString()}");
                      if (service.uuid.toString() == SERVICE_UUID) {
                        service.characteristics.forEach((characteristics) {
                          if (characteristics.uuid.toString() ==
                              CHARACTERISTIC_UUID) {
                            writeData(characteristics, wifiData);
                          }
                        });
                      }
                      // service.characteristics.forEach((characteristics) {
                      //   if (characteristics != null) {
                      //     writeData(characteristics, wifiData);
                      //   }
                      // });
                    });
                  }
                },
                color: Colors.indigoAccent,
                child: Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
