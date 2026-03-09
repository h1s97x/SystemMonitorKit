/// CPU 信息
class CpuInfo {
  CpuInfo({
    required this.usage,
    required this.coreCount,
    this.architecture,
    this.frequency,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory CpuInfo.fromJson(Map<String, dynamic> json) {
    return CpuInfo(
      usage: (json['usage'] as num).toDouble(),
      coreCount: json['coreCount'] as int,
      architecture: json['architecture'] as String?,
      frequency: json['frequency'] != null ? (json['frequency'] as num).toDouble() : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// CPU 使用率 (0-100)
  final double usage;
  
  /// CPU 核心数
  final int coreCount;
  
  /// CPU 架构
  final String? architecture;
  
  /// CPU 频率 (MHz)
  final double? frequency;
  
  /// 采样时间
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'usage': usage,
      'coreCount': coreCount,
      'architecture': architecture,
      'frequency': frequency,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CpuInfo(usage: ${usage.toStringAsFixed(1)}%, cores: $coreCount)';
  }
}
