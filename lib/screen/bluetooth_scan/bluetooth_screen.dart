import 'dart:async';
import 'dart:convert' show utf8;

import 'package:bl_model/sate/bluetooth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import 'scan_result_tile.dart';

class BluetoothScreen extends StatefulWidget {
  BluetoothScreen({Key key}) : super(key: key);

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubscription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";

  @override
  void initState() {
    super.initState();

    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<List<ScanResult>>(
                        stream: FlutterBlue.instance.scanResults,
                        initialData: [],
                        builder: (c, snapshot) => Column(
                          children: snapshot.data
                              .map(
                                (r) => ScanResultTile(
                                    result: r,
                                    onTap: () {
                                      Provider.of<BluetoothProviderState>(
                                              context,
                                              listen: false)
                                          .blueConnect(r, context);
                                    }
                                    // result: r, onTap: () => r.device.connect()
                                    // onTap: () => Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) {
                                    //       r.device.connect();
                                    //     },
                                    //   ),
                                    // ),
                                    ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: StreamBuilder<bool>(
                  stream: FlutterBlue.instance.isScanning,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (snapshot.data) {
                      return CircularProgressIndicator();
                    } else {
                      return OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () => FlutterBlue.instance
                            .startScan(timeout: Duration(seconds: 4)),
                        child: Text(
                          "搜尋",
                          style: TextStyle(fontSize: 15),
                        ),
                        textColor: Colors.blue[200],
                        splashColor: Colors.white38,
                        borderSide: new BorderSide(color: Colors.white60),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: StreamBuilder<bool>(
      //   stream: FlutterBlue.instance.isScanning,
      //   initialData: false,
      //   builder: (c, snapshot) {
      //     if (snapshot.data) {
      //       return FloatingActionButton(
      //         child: Icon(Icons.stop),
      //         onPressed: () => FlutterBlue.instance.stopScan(),
      //         backgroundColor: Colors.red,
      //       );
      //     } else {
      //       return FloatingActionButton(
      //           child: Icon(Icons.search),
      //           onPressed: () => FlutterBlue.instance
      //               .startScan(timeout: Duration(seconds: 4)));
      //     }
      //   },
      // ),
    );
  }
}
