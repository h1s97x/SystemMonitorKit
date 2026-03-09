/// 内存信息
class MemoryInfo {
  /// 总内存 (bytes)
  final int totalMemory;
  
  /// 已使用内存 (bytes)
  final int usedMemory;
  
  /// 可用内存 (bytes)
  final int freeMemory;
  
  /// 内存使用率 (0-100)
  final double usage;
  
  /// 采样时间
  final DateTime timestamp;

  MemoryInfo({
    required this.totalMemory,
    required this.usedMemory,
    required this.freeMemory,
    DateTime? timestamp,
  })  : usage = totalMemory > 0 ? (usedMemory / totalMemory * 100) : 0,
        timestamp = timestamp ?? DateTime.now();

  /// 总内存 (MB)
  double get totalMemoryMB => totalMemory / (1024 * 1024);
  
  /// 已使用内存 (MB)
  double get usedMemoryMB => usedMemory / (1024 * 1024);
  
  /// 可用内存 (MB)
  double get freeMemoryMB => freeMemory / (1024 * 1024);
  
  /// 总内存 (GB)
  double get totalMemoryGB => totalMemory / (1024 * 1024 * 1024);
  
  /// 已使用内存 (GB)
  double get usedMemoryGB => usedMemory / (1024 * 1024 * 1024);
  
  /// 可用内存 (GB)
  double get freeMemoryGB => freeMemory / (1024 * 1024 * 1024);

  Map<String, dynamic> toJson() {
    return {
      'totalMemory': totalMemory,
      'usedMemory': usedMemory,
      'freeMemory': freeMemory,
      'usage': usage,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MemoryInfo.fromJson(Map<String, dynamic> json) {
    return MemoryInfo(
      totalMemory: json['totalMemory'] as int,
      usedMemory: json['usedMemory'] as int,
      freeMemory: json['freeMemory'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() {
    return 'MemoryInfo(used: ${usedMemoryGB.toStringAsFixed(2)}GB / ${totalMemoryGB.toStringAsFixed(2)}GB, ${usage.toStringAsFixed(1)}%)';
  }
}
