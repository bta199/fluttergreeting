import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_app.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

main() async {
  runApp(const MyApp());
  await initialize();
}

Future<void> initialize() async {
  if (!kIsWeb) {
    final ByteData certificateData =
        await rootBundle.load('assets/randomuser.me.crt');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(certificateData.buffer.asUint8List());
  }
}
