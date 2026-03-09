/// 电池状态
enum BatteryState {
  /// 充电中
  charging,
  
  /// 放电中
  discharging,
  
  /// 已充满
  full,
  
  /// 未知
  unknown,
}

/// 电池信息
class BatteryInfo {
  BatteryInfo({
    required this.level,
    required this.state,
    required this.isCharging,
    this.isInBatterySaveMode = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory BatteryInfo.fromJson(Map<String, dynamic> json) {
    return BatteryInfo(
      level: json['level'] as int,
      state: BatteryState.values.firstWhere(
        (e) => e.name == json['state'],
        orElse: () => BatteryState.unknown,
      ),
      isCharging: json['isCharging'] as bool,
      isInBatterySaveMode: json['isInBatterySaveMode'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// 电池电量 (0-100)
  final int level;
  
  /// 电池状态
  final BatteryState state;
  
  /// 是否正在充电
  final bool isCharging;
  
  /// 是否低电量模式
  final bool isInBatterySaveMode;
  
  /// 采样时间
  final DateTime timestamp;

  /// 是否低电量 (< 20%)
  bool get isLowBattery => level < 20;
  
  /// 是否极低电量 (< 10%)
  bool get isCriticalBattery => level < 10;

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'state': state.name,
      'isCharging': isCharging,
      'isInBatterySaveMode': isInBatterySaveMode,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'BatteryInfo(level: $level%, state: ${state.name}, charging: $isCharging)';
  }
}
