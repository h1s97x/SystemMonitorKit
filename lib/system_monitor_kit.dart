/// SystemMonitorKit - 跨平台系统监控库
///
/// 提供实时的系统资源监控功能，包括：
/// - CPU 使用率和硬件信息
/// - 内存使用情况
/// - 磁盘空间信息
/// - 电池状态和电量
/// - 网络流量统计
///
/// 使用示例：
/// ```dart
/// import 'package:system_monitor_kit/system_monitor_kit.dart';
///
/// final monitor = SystemMonitor();
/// final systemInfo = await monitor.getSystemInfo();
/// print('CPU 使用率: ${systemInfo.cpu?.usage}%');
/// print('内存使用率: ${systemInfo.memory?.usage}%');
/// ```
///
/// 支持的平台：
/// - Android (API 21+)
/// - Windows (Windows 10+)
/// - iOS (计划中)
/// - Linux (计划中)
/// - macOS (计划中)
// ignore: unnecessary_library_name
library system_monitor_kit;

export 'src/system_monitor.dart';
export 'src/models/models.dart';
