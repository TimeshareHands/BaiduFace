import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPluginBaiduface {
  static const MethodChannel _channel =
  const MethodChannel('flutter_plugin_baiduface');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<Map> BaiduFaceToRegister(Map message) async{  //静态方法返回一个Map
    //下面这行代码中的map是_channel 方法回调回来的map，而不是静态方法返回的map
    final Map res =await _channel.invokeMethod('BaiduFaceToRegister',<String,dynamic>{'message':message});
    print("flutter $message");
    return res;
  }
  static Future<Map> BaiduFaceToLogin(Map message) async{  //静态方法返回一个Map
    //下面这行代码中的map是_channel 方法回调回来的map，而不是静态方法返回的map
    final Map res =await _channel.invokeMethod('BaiduFaceToLogin',<String,dynamic>{'message':message});
    return res;
  }
}
