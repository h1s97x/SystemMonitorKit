import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart' as bp;
import 'package:disk_space_plus/disk_space_plus.dart';
import 'models/models.dart';

/// 系统监控器
class SystemMonitor {
  static final SystemMonitor _instance = SystemMonitor._internal();
  factory SystemMonitor() => _instance;
  SystemMonitor._internal();

  final _battery = bp.Battery();
  
  // 网络流量追踪
  int _lastReceivedBytes = 0;
  int _lastSentBytes = 0;
  DateTime _lastNetworkCheck = DateTime.now();

  /// 获取电池信息
  Future<BatteryInfo> getBatteryInfo() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      final isInSaveMode = await _battery.isInBatterySaveMode;

      return BatteryInfo(
        level: level,
        state: _mapBatteryState(state),
        isCharging: state == bp.BatteryState.charging,
        isInBatterySaveMode: isInSaveMode,
      );
    } catch (e) {
      debugPrint('Failed to get battery info: $e');
      return BatteryInfo(
        level: 0,
        state: BatteryState.unknown,
        isCharging: false,
      );
    }
  }

  /// 获取电池状态流
  Stream<BatteryInfo> get batteryStream {
    return _battery.onBatteryStateChanged.asyncMap((_) => getBatteryInfo());
  }

  /// 获取 CPU 信息
  Future<CpuInfo> getCpuInfo() async {
    try {
      // 获取 CPU 核心数
      final coreCount = Platform.numberOfProcessors;
      
      // 模拟 CPU 使用率（实际需要平台特定实现）
      final usage = await _estimateCpuUsage();

      return CpuInfo(
        usage: usage,
        coreCount: coreCount,
        architecture: _getCpuArchitecture(),
      );
    } catch (e) {
      debugPrint('Failed to get CPU info: $e');
      return CpuInfo(
        usage: 0,
        coreCount: Platform.numberOfProcessors,
      );
    }
  }

  /// 获取内存信息
  Future<MemoryInfo> getMemoryInfo() async {
    try {
      // 注意：这里使用估算值，实际需要平台特定实现
      final totalMemory = await _estimateTotalMemory();
      final freeMemory = await _estimateFreeMemory();
      final usedMemory = totalMemory - freeMemory;

      return MemoryInfo(
        totalMemory: totalMemory,
        usedMemory: usedMemory,
        freeMemory: freeMemory,
      );
    } catch (e) {
      debugPrint('Failed to get memory info: $e');
      return MemoryInfo(
        totalMemory: 0,
        usedMemory: 0,
        freeMemory: 0,
      );
    }
  }

  /// 获取磁盘信息
  Future<DiskInfo> getDiskInfo() async {
    try {
      final diskSpace = DiskSpacePlus();
      final totalSpace = await diskSpace.getTotalDiskSpace ?? 0;
      final freeSpace = await diskSpace.getFreeDiskSpace ?? 0;
      final usedSpace = totalSpace - freeSpace;

      return DiskInfo(
        totalSpace: (totalSpace * 1024 * 1024).toInt(), // MB to bytes
        usedSpace: (usedSpace * 1024 * 1024).toInt(),
        freeSpace: (freeSpace * 1024 * 1024).toInt(),
      );
    } catch (e) {
      debugPrint('Failed to get disk info: $e');
      return DiskInfo(
        totalSpace: 0,
        usedSpace: 0,
        freeSpace: 0,
      );
    }
  }

  /// 获取网络流量信息
  Future<NetworkTraffic> getNetworkTraffic() async {
    try {
      // 注意：这里使用模拟值，实际需要平台特定实现
      final now = DateTime.now();
      final duration = now.difference(_lastNetworkCheck).inSeconds;
      
      if (duration == 0) {
        return NetworkTraffic(
          receivedBytes: _lastReceivedBytes,
          sentBytes: _lastSentBytes,
          receiveRate: 0,
          sendRate: 0,
        );
      }

      final receivedBytes = _lastReceivedBytes + (1024 * 100); // 模拟接收
      final sentBytes = _lastSentBytes + (1024 * 50); // 模拟发送
      
      final receiveRate = (receivedBytes - _lastReceivedBytes) / duration;
      final sendRate = (sentBytes - _lastSentBytes) / duration;

      _lastReceivedBytes = receivedBytes;
      _lastSentBytes = sentBytes;
      _lastNetworkCheck = now;

      return NetworkTraffic(
        receivedBytes: receivedBytes,
        sentBytes: sentBytes,
        receiveRate: receiveRate,
        sendRate: sendRate,
      );
    } catch (e) {
      debugPrint('Failed to get network traffic: $e');
      return NetworkTraffic(
        receivedBytes: 0,
        sentBytes: 0,
        receiveRate: 0,
        sendRate: 0,
      );
    }
  }

  /// 获取系统综合信息
  Future<SystemInfo> getSystemInfo() async {
    try {
      final results = await Future.wait([
        getCpuInfo(),
        getMemoryInfo(),
        getDiskInfo(),
        getBatteryInfo(),
        getNetworkTraffic(),
      ]);

      return SystemInfo(
        cpu: results[0] as CpuInfo,
        memory: results[1] as MemoryInfo,
        disk: results[2] as DiskInfo,
        battery: results[3] as BatteryInfo,
        network: results[4] as NetworkTraffic,
      );
    } catch (e) {
      debugPrint('Failed to get system info: $e');
      return SystemInfo();
    }
  }

  /// 创建系统监控流
  Stream<SystemInfo> createMonitorStream({
    Duration interval = const Duration(seconds: 1),
  }) {
    return Stream.periodic(interval).asyncMap((_) => getSystemInfo());
  }

  // 辅助方法

  BatteryState _mapBatteryState(bp.BatteryState state) {
    switch (state) {
      case bp.BatteryState.charging:
        return BatteryState.charging;
      case bp.BatteryState.discharging:
        return BatteryState.discharging;
      case bp.BatteryState.full:
        return BatteryState.full;
      default:
        return BatteryState.unknown;
    }
  }

  String? _getCpuArchitecture() {
    if (Platform.isAndroid || Platform.isIOS) {
      // 移动平台通常是 ARM
      return 'ARM';
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // 桌面平台通常是 x86_64
      return 'x86_64';
    }
    return null;
  }

  Future<double> _estimateCpuUsage() async {
    // 简单的 CPU 使用率估算
    // 实际应用中需要平台特定实现
    await Future.delayed(const Duration(milliseconds: 100));
    return 25.0 + (DateTime.now().millisecond % 50);
  }

  Future<int> _estimateTotalMemory() async {
    // 估算总内存（实际需要平台特定实现）
    if (Platform.isAndroid || Platform.isIOS) {
      return 8 * 1024 * 1024 * 1024; // 8GB
    } else {
      return 16 * 1024 * 1024 * 1024; // 16GB
    }
  }

  Future<int> _estimateFreeMemory() async {
    // 估算可用内存（实际需要平台特定实现）
    final total = await _estimateTotalMemory();
    return (total * 0.4).toInt(); // 假设 40% 可用
  }
}
