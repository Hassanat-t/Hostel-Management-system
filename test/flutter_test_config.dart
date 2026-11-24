// Runs before every test file in test/ and its subfolders.
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Widget tests have no internet, so google_fonts must not try to download.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Without real fonts, Flutter tests draw every letter as a wide square,
  // which makes rows overflow that fit fine on a phone. Load Roboto (shipped
  // with the Flutter SDK) under every font family the app asks for, so text
  // in tests has realistic widths.
  await _loadRealFonts();

  await testMain();
}

const _families = ['Roboto', 'Inter', 'Poppins', 'Manrope'];

Future<void> _loadRealFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'];
  final dir = Directory('$root/bin/cache/artifacts/material_fonts');
  if (root == null || !dir.existsSync()) {
    print('flutter_test_config: Roboto not found, tests use the square test font.');
    return;
  }

  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) {
        // File names are lowercase on some installs (roboto-regular.ttf).
        final name = f.uri.pathSegments.last.toLowerCase();
        return name.startsWith('roboto-') && name.endsWith('.ttf');
      })
      .toList();
  if (files.isEmpty) {
    print('flutter_test_config: no roboto-*.ttf in ${dir.path}.');
    return;
  }

  for (final family in _families) {
    final loader = FontLoader(family);
    for (final file in files) {
      final bytes = file.readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }
}
