import 'package:bl_model/sate/bluetooth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key key, this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.length > 0) {
      return 
          Text(
            result.device.name,
            overflow: TextOverflow.ellipsis,
          // Text(
          //   result.device.id.toString(),
          //   style: Theme.of(context).textTheme.caption,
          // )
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    var blueProviderState = Provider.of<BluetoothProviderState>(context);
    return ExpansionTile(
      title: Column(children: [
        _buildTitle(context),
        Text("====${blueProviderState.connectBluetoothState}")
      ],),
      leading: SignalStrengthIndicator.bars(
        value: (100 - (result.rssi * -1)) * 0.01,
        size: 20,
        barCount: 5,
        activeColor: Colors.blue,
        inactiveColor: Colors.blue[100],
      ),
      trailing: blueProviderState.connectBluetoothState
          ? CircularProgressIndicator()
          : IconButton(
              icon: Icon(Icons.chevron_right_outlined),
              onPressed: (result.advertisementData.connectable) ? onTap : null,
            ),
      // trailing: RaisedButton(
      //   child: Text('CONNECT'),
      //   color: Colors.black,
      //   textColor: Colors.white,
      //   onPressed: (result.advertisementData.connectable) ? onTap : null,
      // ),
    );
  }
}
