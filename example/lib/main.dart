import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_baiduface/flutter_plugin_baiduface.dart';

void main() {
  runApp(new MaterialApp(home: BaidDuFace(),));
}

class BaidDuFace extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<BaidDuFace> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.only(top: 20),
              child: Container(

                child: Text('人脸信息录入',style: TextStyle(color: Colors.white,fontSize: 20.0),textAlign:TextAlign.center,),
                decoration: BoxDecoration(color: Colors.orangeAccent),
                width: 200,
                height: 33,
              ),
              onPressed:() async{
                Map  msg = await  FlutterPluginBaiduface.BaiduFaceToRegister({"message":"人脸信息录入"});
                print(msg);
                _showMyMaterialDialog(msg.toString());
//                 Navigator.pushNamed(context, ' GoToFaceRegister');
              } ,
            ),
            FlatButton(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                child: Text('人脸信息识别',style: TextStyle(color: Colors.white,fontSize: 20.0),textAlign:TextAlign.center,),
                decoration: BoxDecoration(color: Colors.orangeAccent),
                width: 200,
                height: 33,
              ),
              onPressed:() async{
                Map  msg = await FlutterPluginBaiduface.BaiduFaceToLogin({"message":"人脸信息识别"});
                print(msg);
                _showMyMaterialDialog(msg.toString());
              } ,
            ),
          ],
        ),
      ),
    );

  }
  Future<void> _showMyMaterialDialog(String msg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('回调数据'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
