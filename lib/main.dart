import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haiduong_sipas/models/app_model.dart';
import 'package:haiduong_sipas/route.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data = await PlatformAssetBundle()
      .load('assets/ca/haiduong_cchc_com_vn_cert.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppModel(),
        child: MaterialApp(
          initialRoute: Routes.initialRoute,
          debugShowCheckedModeBanner: false,
          routes: Routes.pages,
          builder: EasyLoading.init(),
        ));
  }
}
