# system_monitor_kit API 参考

本文档提供 system_monitor_kit 的完整 API 参考。

## 目录

- [system\_monitor\_kit API 参考](#system_monitor_kit-api-参考)
  - [目录](#目录)
  - [SystemMonitor](#systemmonitor)
    - [实例方法](#实例方法)
      - [getSystemInfo](#getsysteminfo)
      - [getCpuInfo](#getcpuinfo)
      - [getMemoryInfo](#getmemoryinfo)
      - [getDiskInfo](#getdiskinfo)
      - [getBatteryInfo](#getbatteryinfo)
      - [getNetworkTraffic](#getnetworktraffic)
      - [createMonitorStream](#createmonitorstream)
    - [属性](#属性)
      - [batteryStream](#batterystream)
  - [数据模型](#数据模型)
    - [SystemInfo](#systeminfo)
    - [CpuInfo](#cpuinfo)
    - [MemoryInfo](#memoryinfo)
    - [DiskInfo](#diskinfo)
    - [BatteryInfo](#batteryinfo)
    - [NetworkTraffic](#networktraffic)
  - [枚举类型](#枚举类型)
    - [BatteryState](#batterystate)
  - [完整示例](#完整示例)

---

## SystemMonitor

主类，用于访问系统监控信息。使用单例模式。

### 实例方法

#### getSystemInfo

```dart
Future<SystemInfo> getSystemInfo()
```

获取所有系统信息（CPU、内存、磁盘、电池、网络）。

**返回:** `Future<SystemInfo>` - 包含所有系统信息的对象

**示例:**

```dart
final monitor = SystemMonitor();
final systemInfo = await monitor.getSystemInfo();
print('CPU: ${systemInfo.cpu?.usage.toStringAsFixed(1)}%');
print('内存: ${systemInfo.memory?.totalMemoryGB.toStringAsFixed(2)} GB');
```

#### getCpuInfo

```dart
Future<CpuInfo> getCpuInfo()
```

获取 CPU 信息。

**返回:** `Future<CpuInfo>` - CPU 信息对象

**示例:**

```dart
final monitor = SystemMonitor();
final cpuInfo = await monitor.getCpuInfo();
print('CPU 使用率: ${cpuInfo.usage.toStringAsFixed(1)}%');
print('核心数: ${cpuInfo.coreCount}');
print('架构: ${cpuInfo.architecture}');
```

#### getMemoryInfo

```dart
Future<MemoryInfo> getMemoryInfo()
```

获取内存信息。

**返回:** `Future<MemoryInfo>` - 内存信息对象

**示例:**

```dart
final monitor = SystemMonitor();
final memoryInfo = await monitor.getMemoryInfo();
print('总内存: ${memoryInfo.totalMemoryGB.toStringAsFixed(2)} GB');
print('可用内存: ${memoryInfo.freeMemoryGB.toStringAsFixed(2)} GB');
print('使用率: ${memoryInfo.usage.toStringAsFixed(1)}%');
```

#### getDiskInfo

```dart
Future<DiskInfo> getDiskInfo()
```

获取磁盘信息。

**返回:** `Future<DiskInfo>` - 磁盘信息对象

**示例:**

```dart
final monitor = SystemMonitor();
final diskInfo = await monitor.getDiskInfo();
print('总空间: ${diskInfo.totalSpaceGB.toStringAsFixed(2)} GB');
print('可用空间: ${diskInfo.freeSpaceGB.toStringAsFixed(2)} GB');
print('使用率: ${diskInfo.usage.toStringAsFixed(1)}%');
```

#### getBatteryInfo

```dart
Future<BatteryInfo> getBatteryInfo()
```

获取电池信息。

**返回:** `Future<BatteryInfo>` - 电池信息对象

**示例:**

```dart
final monitor = SystemMonitor();
final batteryInfo = await monitor.getBatteryInfo();
print('电量: ${batteryInfo.level}%');
print('充电中: ${batteryInfo.isCharging}');
print('状态: ${batteryInfo.state.name}');
print('低电量模式: ${batteryInfo.isInBatterySaveMode}');
```

#### getNetworkTraffic

```dart
Future<NetworkTraffic> getNetworkTraffic()
```

获取网络流量信息。

**返回:** `Future<NetworkTraffic>` - 网络流量对象

**示例:**

```dart
final monitor = SystemMonitor();
final networkTraffic = await monitor.getNetworkTraffic();
print('接收: ${networkTraffic.receivedMB.toStringAsFixed(2)} MB');
print('发送: ${networkTraffic.sentMB.toStringAsFixed(2)} MB');
print('下载速率: ${networkTraffic.receiveRateKBps.toStringAsFixed(1)} KB/s');
print('上传速率: ${networkTraffic.sendRateKBps.toStringAsFixed(1)} KB/s');
```

#### createMonitorStream

```dart
Stream<SystemInfo> createMonitorStream({
  Duration interval = const Duration(seconds: 1),
})
```

创建系统监控流，定期获取系统信息。

**参数:**
- `interval`: 更新间隔，默认 1 秒

**返回:** `Stream<SystemInfo>` - 系统信息流

**示例:**

```dart
final monitor = SystemMonitor();
final stream = monitor.createMonitorStream(
  interval: Duration(seconds: 2),
);

stream.listen((systemInfo) {
  print('CPU: ${systemInfo.cpu?.usage.toStringAsFixed(1)}%');
  print('内存: ${systemInfo.memory?.usage.toStringAsFixed(1)}%');
});
```

### 属性

#### batteryStream

```dart
Stream<BatteryInfo> get batteryStream
```

电池状态变化流。当电池状态改变时自动触发。

**返回:** `Stream<BatteryInfo>` - 电池信息流

**示例:**

```dart
final monitor = SystemMonitor();
monitor.batteryStream.listen((batteryInfo) {
  print('电池状态变化: ${batteryInfo.level}%');
  if (batteryInfo.isLowBattery) {
    print('警告: 电量低！');
  }
});
```

---

## 数据模型

### SystemInfo

完整的系统信息。

```dart
class SystemInfo {
  final CpuInfo? cpu;              // CPU 信息
  final MemoryInfo? memory;        // 内存信息
  final DiskInfo? disk;            // 磁盘信息
  final BatteryInfo? battery;      // 电池信息
  final NetworkTraffic? network;   // 网络流量
  final DateTime timestamp;        // 采样时间
}
```

### CpuInfo

CPU/处理器信息。

```dart
class CpuInfo {
  final double usage;          // CPU 使用率 (0-100)
  final int coreCount;         // CPU 核心数
  final String? architecture;  // CPU 架构 (ARM, x86_64 等)
  final double? frequency;     // CPU 频率 (MHz)
  final DateTime timestamp;    // 采样时间
}
```

### MemoryInfo

内存（RAM）信息。

```dart
class MemoryInfo {
  final int totalMemory;       // 总内存 (bytes)
  final int usedMemory;        // 已用内存 (bytes)
  final int freeMemory;        // 可用内存 (bytes)
  final double usage;          // 使用率 (0-100)
  final DateTime timestamp;    // 采样时间
  
  // 便捷 getter
  double get totalMemoryMB;    // 总内存 (MB)
  double get usedMemoryMB;     // 已用内存 (MB)
  double get freeMemoryMB;     // 可用内存 (MB)
  double get totalMemoryGB;    // 总内存 (GB)
  double get usedMemoryGB;     // 已用内存 (GB)
  double get freeMemoryGB;     // 可用内存 (GB)
}
```

### DiskInfo

磁盘/存储信息。

```dart
class DiskInfo {
  final int totalSpace;        // 总空间 (bytes)
  final int usedSpace;         // 已用空间 (bytes)
  final int freeSpace;         // 可用空间 (bytes)
  final double usage;          // 使用率 (0-100)
  final DateTime timestamp;    // 采样时间
  
  // 便捷 getter
  double get totalSpaceMB;     // 总空间 (MB)
  double get usedSpaceMB;      // 已用空间 (MB)
  double get freeSpaceMB;      // 可用空间 (MB)
  double get totalSpaceGB;     // 总空间 (GB)
  double get usedSpaceGB;      // 已用空间 (GB)
  double get freeSpaceGB;      // 可用空间 (GB)
}
```

### BatteryInfo

电池信息。

```dart
class BatteryInfo {
  final int level;                    // 电量 (0-100)
  final BatteryState state;           // 电池状态
  final bool isCharging;              // 是否正在充电
  final bool isInBatterySaveMode;     // 是否低电量模式
  final DateTime timestamp;           // 采样时间
  
  // 便捷 getter
  bool get isLowBattery;              // 是否低电量 (< 20%)
  bool get isCriticalBattery;         // 是否极低电量 (< 10%)
}
```

### NetworkTraffic

网络流量信息。

```dart
class NetworkTraffic {
  final int receivedBytes;     // 接收字节数
  final int sentBytes;         // 发送字节数
  final double receiveRate;    // 接收速率 (bytes/s)
  final double sendRate;       // 发送速率 (bytes/s)
  final DateTime timestamp;    // 采样时间
  
  // 便捷 getter
  double get receivedMB;       // 接收流量 (MB)
  double get sentMB;           // 发送流量 (MB)
  double get totalMB;          // 总流量 (MB)
  double get receiveRateKBps;  // 接收速率 (KB/s)
  double get sendRateKBps;     // 发送速率 (KB/s)
  double get receiveRateMBps;  // 接收速率 (MB/s)
  double get sendRateMBps;     // 发送速率 (MB/s)
}
```

---

## 枚举类型

### BatteryState

电池状态枚举。

```dart
enum BatteryState {
  charging,      // 充电中
  discharging,   // 放电中
  full,          // 已充满
  unknown,       // 未知
}
```

---

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:system_monitor_kit/system_monitor_kit.dart';

class SystemMonitorPage extends StatefulWidget {
  const SystemMonitorPage({super.key});

  @override
  State<SystemMonitorPage> createState() => _SystemMonitorPageState();
}

class _SystemMonitorPageState extends State<SystemMonitorPage> {
  final _monitor = SystemMonitor();
  SystemInfo? _systemInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
    setState(() {
      _loading = true;
    });

    try {
      final systemInfo = await _monitor.getSystemInfo();
      setState(() {
        _systemInfo = systemInfo;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取系统信息失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_systemInfo == null) {
      return const Center(child: Text('无法获取系统信息'));
    }

    final info = _systemInfo!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection('CPU', [
          _buildItem('使用率', '${info.cpu?.usage.toStringAsFixed(1)}%'),
          _buildItem('核心数', '${info.cpu?.coreCount}'),
          _buildItem('架构', info.cpu?.architecture ?? 'N/A'),
        ]),
        _buildSection('内存', [
          _buildItem('总内存', '${info.memory?.totalMemoryGB.toStringAsFixed(2)} GB'),
          _buildItem('可用内存', '${info.memory?.freeMemoryGB.toStringAsFixed(2)} GB'),
          _buildItem('使用率', '${info.memory?.usage.toStringAsFixed(1)}%'),
        ]),
        _buildSection('磁盘', [
          _buildItem('总空间', '${info.disk?.totalSpaceGB.toStringAsFixed(2)} GB'),
          _buildItem('可用空间', '${info.disk?.freeSpaceGB.toStringAsFixed(2)} GB'),
          _buildItem('使用率', '${info.disk?.usage.toStringAsFixed(1)}%'),
        ]),
        _buildSection('电池', [
          _buildItem('电量', '${info.battery?.level}%'),
          _buildItem('状态', info.battery?.state.name ?? 'N/A'),
          _buildItem('充电中', '${info.battery?.isCharging}'),
        ]),
        _buildSection('网络', [
          _buildItem('接收', '${info.network?.receivedMB.toStringAsFixed(2)} MB'),
          _buildItem('发送', '${info.network?.sentMB.toStringAsFixed(2)} MB'),
          _buildItem('下载速率', '${info.network?.receiveRateKBps.toStringAsFixed(1)} KB/s'),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }
}
```

---

**文档版本**: 1.0  
**更新日期**: 2026-03-09  
**项目**: system_monitor_kit
