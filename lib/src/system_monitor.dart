import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart' as bp;
import 'package:disk_space_plus/disk_space_plus.dart';
import 'models/models.dart';

/// 系统监控器
///
/// 单例模式的系统监控类，提供获取系统资源信息的方法。
/// 支持实时监控流和单次查询两种方式。
///
/// 使用示例：
/// ```dart
/// final monitor = SystemMonitor();
///
/// // 单次查询
/// final cpuInfo = await monitor.getCpuInfo();
/// print('CPU 使用率: ${cpuInfo.usage}%');
///
/// // 实时监控流
/// monitor.createMonitorStream(interval: Duration(seconds: 1))
///   .listen((systemInfo) {
///     print('系统信息: $systemInfo');
///   });
/// ```
class SystemMonitor {
  factory SystemMonitor() => _instance;
  SystemMonitor._internal();

  static final SystemMonitor _instance = SystemMonitor._internal();

  final _battery = bp.Battery();

  // 网络流量追踪
  int _lastReceivedBytes = 0;
  int _lastSentBytes = 0;
  DateTime _lastNetworkCheck = DateTime.now();

  /// 获取电池信息
  ///
  /// 返回当前设备的电池状态信息，包括电量、充电状态等。
  ///
  /// 返回值：
  /// - [BatteryInfo] 包含电池电量、状态、充电状态等信息
  ///
  /// 异常：
  /// - 如果获取失败，返回默认的 [BatteryInfo] 对象
  ///
  /// 使用示例：
  /// ```dart
  /// final battery = await monitor.getBatteryInfo();
  /// print('电量: ${battery.level}%');
  /// print('充电中: ${battery.isCharging}');
  /// print('低电量: ${battery.isLowBattery}');
  /// ```
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
  ///
  /// 返回一个 Stream，当电池状态发生变化时会发出新的 [BatteryInfo]。
  /// 这对于实时监控电池状态变化很有用。
  ///
  /// 返回值：
  /// - [Stream<BatteryInfo>] 电池状态变化流
  ///
  /// 使用示例：
  /// ```dart
  /// monitor.batteryStream.listen((battery) {
  ///   print('电池状态已更新: ${battery.state}');
  ///   if (battery.isLowBattery) {
  ///     print('警告: 电量不足!');
  ///   }
  /// });
  /// ```
  Stream<BatteryInfo> get batteryStream {
    return _battery.onBatteryStateChanged.asyncMap((_) => getBatteryInfo());
  }

  /// 获取 CPU 信息
  ///
  /// 返回当前设备的 CPU 信息，包括使用率、核心数、架构等。
  ///
  /// 返回值：
  /// - [CpuInfo] 包含 CPU 使用率、核心数、架构等信息
  ///
  /// 注意：
  /// - CPU 使用率是估算值，实际需要平台特定实现
  /// - 不同平台的精度可能不同
  ///
  /// 使用示例：
  /// ```dart
  /// final cpu = await monitor.getCpuInfo();
  /// print('CPU 使用率: ${cpu.usage.toStringAsFixed(1)}%');
  /// print('核心数: ${cpu.coreCount}');
  /// print('架构: ${cpu.architecture}');
  /// ```
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
  ///
  /// 返回当前设备的内存使用情况，包括总内存、已用内存、可用内存等。
  ///
  /// 返回值：
  /// - [MemoryInfo] 包含内存统计信息
  ///
  /// 注意：
  /// - 内存信息是估算值，实际需要平台特定实现
  /// - 不同平台的精度可能不同
  ///
  /// 使用示例：
  /// ```dart
  /// final memory = await monitor.getMemoryInfo();
  /// print('总内存: ${memory.totalMemoryGB.toStringAsFixed(2)}GB');
  /// print('已用: ${memory.usedMemoryGB.toStringAsFixed(2)}GB');
  /// print('使用率: ${memory.usage.toStringAsFixed(1)}%');
  /// ```
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
  ///
  /// 返回设备的磁盘空间信息，包括总空间、已用空间、可用空间等。
  /// 不同平台的实现方式不同：
  /// - 移动平台 (Android/iOS): 使用 disk_space_plus 包
  /// - 桌面平台 (Windows/Linux/macOS): 使用 disk_space_plus 包
  ///
  /// 返回值：
  /// - [DiskInfo] 包含磁盘空间信息
  ///
  /// 使用示例：
  /// ```dart
  /// final disk = await monitor.getDiskInfo();
  /// print('总空间: ${disk.totalSpaceGB.toStringAsFixed(2)}GB');
  /// print('已用: ${disk.usedSpaceGB.toStringAsFixed(2)}GB');
  /// print('使用率: ${disk.usage.toStringAsFixed(1)}%');
  /// ```
  Future<DiskInfo> getDiskInfo() async {
    try {
      // 使用 disk_space_plus 获取磁盘信息
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
      // 静默处理错误
      return DiskInfo(
        totalSpace: 0,
        usedSpace: 0,
        freeSpace: 0,
      );
    }
  }

  /// 获取网络流量信息
  ///
  /// 返回网络流量统计信息，包括接收/发送字节数和速率。
  ///
  /// 返回值：
  /// - [NetworkTraffic] 包含网络流量信息
  ///
  /// 注意：
  /// - 网络流量是模拟值，实际需要平台特定实现
  /// - 速率是基于两次查询之间的时间差计算的
  ///
  /// 使用示例：
  /// ```dart
  /// final traffic = await monitor.getNetworkTraffic();
  /// print('接收速率: ${traffic.receiveRateKBps.toStringAsFixed(1)}KB/s');
  /// print('发送速率: ${traffic.sendRateKBps.toStringAsFixed(1)}KB/s');
  /// print('总流量: ${traffic.totalMB.toStringAsFixed(2)}MB');
  /// ```
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
  ///
  /// 一次性获取所有系统信息（CPU、内存、磁盘、电池、网络）。
  /// 这是一个便捷方法，相当于并发调用所有单个获取方法。
  ///
  /// 返回值：
  /// - [SystemInfo] 包含所有系统信息
  ///
  /// 使用示例：
  /// ```dart
  /// final systemInfo = await monitor.getSystemInfo();
  /// print('系统信息:');
  /// print('  CPU: ${systemInfo.cpu}');
  /// print('  内存: ${systemInfo.memory}');
  /// print('  磁盘: ${systemInfo.disk}');
  /// print('  电池: ${systemInfo.battery}');
  /// print('  网络: ${systemInfo.network}');
  /// ```
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
  ///
  /// 创建一个定期发出系统信息的 Stream。
  /// 可用于实时监控系统资源变化。
  ///
  /// 参数：
  /// - [interval] 监控间隔，默认为 1 秒
  ///
  /// 返回值：
  /// - [Stream<SystemInfo>] 系统信息流
  ///
  /// 使用示例：
  /// ```dart
  /// monitor.createMonitorStream(interval: Duration(seconds: 2))
  ///   .listen((systemInfo) {
  ///     print('CPU: ${systemInfo.cpu?.usage}%');
  ///     print('内存: ${systemInfo.memory?.usage}%');
  ///   });
  /// ```
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
