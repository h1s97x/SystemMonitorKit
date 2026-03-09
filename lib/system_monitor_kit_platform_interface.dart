import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'system_monitor_kit_method_channel.dart';

abstract class SystemMonitorKitPlatform extends PlatformInterface {
  /// Constructs a SystemMonitorKitPlatform.
  SystemMonitorKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static SystemMonitorKitPlatform _instance = MethodChannelSystemMonitorKit();

  /// The default instance of [SystemMonitorKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelSystemMonitorKit].
  static SystemMonitorKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SystemMonitorKitPlatform] when
  /// they register themselves.
  static set instance(SystemMonitorKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
