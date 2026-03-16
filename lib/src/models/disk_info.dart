/// 磁盘信息
///
/// 包含设备磁盘的详细信息，包括总空间、已用空间、可用空间等。
/// 提供多种单位的便捷访问方法（bytes、MB、GB）。
///
/// 使用示例：
/// ```dart
/// final disk = DiskInfo(
///   totalSpace: 256 * 1024 * 1024 * 1024,
///   usedSpace: 128 * 1024 * 1024 * 1024,
///   freeSpace: 128 * 1024 * 1024 * 1024,
/// );
/// print('总空间: ${disk.totalSpaceGB.toStringAsFixed(2)}GB');
/// print('使用率: ${disk.usage.toStringAsFixed(1)}%');
/// ```
class DiskInfo {
  DiskInfo({
    required this.totalSpace,
    required this.usedSpace,
    required this.freeSpace,
    DateTime? timestamp,
  })  : usage = totalSpace > 0 ? (usedSpace / totalSpace * 100) : 0,
        timestamp = timestamp ?? DateTime.now();

  factory DiskInfo.fromJson(Map<String, dynamic> json) {
    return DiskInfo(
      totalSpace: json['totalSpace'] as int,
      usedSpace: json['usedSpace'] as int,
      freeSpace: json['freeSpace'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// 总空间 (bytes)
  final int totalSpace;
  
  /// 已使用空间 (bytes)
  final int usedSpace;
  
  /// 可用空间 (bytes)
  final int freeSpace;
  
  /// 磁盘使用率 (0-100)
  final double usage;
  
  /// 采样时间
  final DateTime timestamp;

  /// 总空间 (MB)
  double get totalSpaceMB => totalSpace / (1024 * 1024);
  
  /// 已使用空间 (MB)
  double get usedSpaceMB => usedSpace / (1024 * 1024);
  
  /// 可用空间 (MB)
  double get freeSpaceMB => freeSpace / (1024 * 1024);
  
  /// 总空间 (GB)
  double get totalSpaceGB => totalSpace / (1024 * 1024 * 1024);
  
  /// 已使用空间 (GB)
  double get usedSpaceGB => usedSpace / (1024 * 1024 * 1024);
  
  /// 可用空间 (GB)
  double get freeSpaceGB => freeSpace / (1024 * 1024 * 1024);

  Map<String, dynamic> toJson() {
    return {
      'totalSpace': totalSpace,
      'usedSpace': usedSpace,
      'freeSpace': freeSpace,
      'usage': usage,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DiskInfo(used: ${usedSpaceGB.toStringAsFixed(2)}GB / ${totalSpaceGB.toStringAsFixed(2)}GB, ${usage.toStringAsFixed(1)}%)';
  }
}
