import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'system_monitor_kit_platform_interface.dart';

/// An implementation of [SystemMonitorKitPlatform] that uses method channels.
class MethodChannelSystemMonitorKit extends SystemMonitorKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('system_monitor_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
