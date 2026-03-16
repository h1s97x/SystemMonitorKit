import 'cpu_info.dart';
import 'memory_info.dart';
import 'disk_info.dart';
import 'battery_info.dart';
import 'network_traffic.dart';

/// 系统综合信息
///
/// 包含所有系统资源的综合信息，包括 CPU、内存、磁盘、电池、网络等。
/// 这是一个聚合类，用于一次性获取所有系统信息。
///
/// 使用示例：
/// ```dart
/// final systemInfo = SystemInfo(
///   cpu: cpuInfo,
///   memory: memoryInfo,
///   disk: diskInfo,
///   battery: batteryInfo,
///   network: networkTraffic,
/// );
/// print('系统信息: $systemInfo');
/// ```
class SystemInfo {
  SystemInfo({
    this.cpu,
    this.memory,
    this.disk,
    this.battery,
    this.network,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    return SystemInfo(
      cpu: json['cpu'] != null ? CpuInfo.fromJson(json['cpu']) : null,
      memory: json['memory'] != null ? MemoryInfo.fromJson(json['memory']) : null,
      disk: json['disk'] != null ? DiskInfo.fromJson(json['disk']) : null,
      battery: json['battery'] != null ? BatteryInfo.fromJson(json['battery']) : null,
      network: json['network'] != null ? NetworkTraffic.fromJson(json['network']) : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// CPU 信息
  final CpuInfo? cpu;
  
  /// 内存信息
  final MemoryInfo? memory;
  
  /// 磁盘信息
  final DiskInfo? disk;
  
  /// 电池信息
  final BatteryInfo? battery;
  
  /// 网络流量
  final NetworkTraffic? network;
  
  /// 采样时间
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'cpu': cpu?.toJson(),
      'memory': memory?.toJson(),
      'disk': disk?.toJson(),
      'battery': battery?.toJson(),
      'network': network?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SystemInfo(cpu: $cpu, memory: $memory, disk: $disk, battery: $battery, network: $network)';
  }
}
