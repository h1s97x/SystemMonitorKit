/// 网络流量信息
///
/// 包含网络流量的详细信息，包括接收/发送字节数和速率。
/// 提供多种单位的便捷访问方法（bytes、KB/s、MB/s）。
///
/// 使用示例：
/// ```dart
/// final traffic = NetworkTraffic(
///   receivedBytes: 1024 * 1024,
///   sentBytes: 512 * 1024,
///   receiveRate: 1024 * 100,
///   sendRate: 1024 * 50,
/// );
/// print('接收速率: ${traffic.receiveRateKBps.toStringAsFixed(1)}KB/s');
/// print('发送速率: ${traffic.sendRateKBps.toStringAsFixed(1)}KB/s');
/// ```
class NetworkTraffic {
  NetworkTraffic({
    required this.receivedBytes,
    required this.sentBytes,
    required this.receiveRate,
    required this.sendRate,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory NetworkTraffic.fromJson(Map<String, dynamic> json) {
    return NetworkTraffic(
      receivedBytes: json['receivedBytes'] as int,
      sentBytes: json['sentBytes'] as int,
      receiveRate: (json['receiveRate'] as num).toDouble(),
      sendRate: (json['sendRate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// 接收字节数
  final int receivedBytes;

  /// 发送字节数
  final int sentBytes;

  /// 接收速率 (bytes/s)
  final double receiveRate;

  /// 发送速率 (bytes/s)
  final double sendRate;

  /// 采样时间
  final DateTime timestamp;

  /// 接收流量 (MB)
  double get receivedMB => receivedBytes / (1024 * 1024);

  /// 发送流量 (MB)
  double get sentMB => sentBytes / (1024 * 1024);

  /// 总流量 (MB)
  double get totalMB => (receivedBytes + sentBytes) / (1024 * 1024);

  /// 接收速率 (KB/s)
  double get receiveRateKBps => receiveRate / 1024;

  /// 发送速率 (KB/s)
  double get sendRateKBps => sendRate / 1024;

  /// 接收速率 (MB/s)
  double get receiveRateMBps => receiveRate / (1024 * 1024);

  /// 发送速率 (MB/s)
  double get sendRateMBps => sendRate / (1024 * 1024);

  Map<String, dynamic> toJson() {
    return {
      'receivedBytes': receivedBytes,
      'sentBytes': sentBytes,
      'receiveRate': receiveRate,
      'sendRate': sendRate,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'NetworkTraffic(↓${receiveRateKBps.toStringAsFixed(1)}KB/s, ↑${sendRateKBps.toStringAsFixed(1)}KB/s)';
  }
}
