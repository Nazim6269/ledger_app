import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger instance = Logger(
    // printer: PrettyPrinter(
    //   methodCount: 0,
    //   errorMethodCount: 8,
    //   lineLength: 120,
    //   colors: true,
    //   printEmojis: true,
    //   dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    // ),
    // level: kReleaseMode ? Level.off : Level.trace,
  );
}

