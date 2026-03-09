# system_monitor_kit 快速参考

本文档提供 system_monitor_kit 的快速参考指南。

## 快速开始

### 安装

```yaml
dependencies:
  system_monitor_kit: ^1.0.0
```

```bash
flutter pub get
```

### 基本使用

```dart
import 'package:system_monitor_kit/system_monitor_kit.dart';

// 创建监控器实例
final monitor = SystemMonitor();

// 获取所有系统信息
final systemInfo = await monitor.getSystemInfo();

// 获取特定硬件信息
final cpuInfo = await monitor.getCpuInfo();
final memoryInfo = await monitor.getMemoryInfo();
final batteryInfo = await monitor.getBatteryInfo();
```

---

## API 速查

### 主要方法

| 方法 | 返回类型 | 说明 |
|------|---------|------|
| `getSystemInfo()` | `Future<SystemInfo>` | 获取所有系统信息 |
| `getCpuInfo()` | `Future<CpuInfo>` | 获取 CPU 信息 |
| `getMemoryInfo()` | `Future<MemoryInfo>` | 获取内存信息 |
| `getDiskInfo()` | `Future<DiskInfo>` | 获取磁盘信息 |
| `getBatteryInfo()` | `Future<BatteryInfo>` | 获取电池信息 |
| `getNetworkTraffic()` | `Future<NetworkTraffic>` | 获取网络流量信息 |
| `createMonitorStream()` | `Stream<SystemInfo>` | 创建系统监控流 |
| `batteryStream` | `Stream<BatteryInfo>` | 电池状态流 |

---

## 数据模型速查

### CpuInfo

```dart
class CpuInfo {
  final double usage;            // CPU 使用率 (%)
  final int coreCount;           // 核心数
  final String? architecture;    // 架构
}
```

### MemoryInfo

```dart
class MemoryInfo {
  final int totalMemory;         // 总内存 (bytes)
  final int usedMemory;          // 已用内存 (bytes)
  final int freeMemory;          // 可用内存 (bytes)
  
  // 便捷 getter
  double get usagePercentage;    // 使用率 (%)
  double get totalMemoryGB;      // 总内存 (GB)
  double get usedMemoryGB;       // 已用内存 (GB)
  double get freeMemoryGB;       // 可用内存 (GB)
}
```

### DiskInfo

```dart
class DiskInfo {
  final int totalSpace;          // 总空间 (bytes)
  final int usedSpace;           // 已用空间 (bytes)
  final int freeSpace;           // 可用空间 (bytes)
  
  // 便捷 getter
  double get usagePercentage;    // 使用率 (%)
  double get totalSpaceGB;       // 总空间 (GB)
  double get usedSpaceGB;        // 已用空间 (GB)
  double get freeSpaceGB;        // 可用空间 (GB)
}
```

### BatteryInfo

```dart
class BatteryInfo {
  final int level;               // 电量 (0-100)
  final BatteryState state;      // 电池状态
  final bool isCharging;         // 是否充电中
  final bool? isInBatterySaveMode; // 是否省电模式
}

enum BatteryState {
  charging,                      // 充电中
  discharging,                   // 放电中
  full,                          // 已充满
  unknown,                       // 未知
}
```

### NetworkTraffic

```dart
class NetworkTraffic {
  final int receivedBytes;       // 接收字节数
  final int sentBytes;           // 发送字节数
  final double receiveRate;      // 接收速率 (bytes/s)
  final double sendRate;         // 发送速率 (bytes/s)
  
  // 便捷 getter
  double get receivedMB;         // 接收 (MB)
  double get sentMB;             // 发送 (MB)
  double get receiveRateMBps;    // 接收速率 (MB/s)
  double get sendRateMBps;       // 发送速率 (MB/s)
}
```

---

## 常用代码片段

### 显示 CPU 信息

```dart
final monitor = SystemMonitor();
final cpuInfo = await monitor.getCpuInfo();
print('CPU 使用率: ${cpuInfo.usage.toStringAsFixed(1)}%');
print('核心数: ${cpuInfo.coreCount}');
print('架构: ${cpuInfo.architecture}');
```

### 显示内存信息

```dart
final monitor = SystemMonitor();
final memoryInfo = await monitor.getMemoryInfo();
print('总内存: ${memoryInfo.totalMemoryGB.toStringAsFixed(2)} GB');
print('可用内存: ${memoryInfo.freeMemoryGB.toStringAsFixed(2)} GB');
print('使用率: ${memoryInfo.usagePercentage.toStringAsFixed(1)}%');
```

### 显示磁盘信息

```dart
final monitor = SystemMonitor();
final diskInfo = await monitor.getDiskInfo();
print('总空间: ${diskInfo.totalSpaceGB.toStringAsFixed(2)} GB');
print('可用空间: ${diskInfo.freeSpaceGB.toStringAsFixed(2)} GB');
print('使用率: ${diskInfo.usagePercentage.toStringAsFixed(1)}%');
```

### 显示电池信息

```dart
final monitor = SystemMonitor();
final batteryInfo = await monitor.getBatteryInfo();
print('电量: ${batteryInfo.level}%');
print('充电中: ${batteryInfo.isCharging}');
print('状态: ${batteryInfo.state}');
```

### 显示网络流量

```dart
final monitor = SystemMonitor();
final networkTraffic = await monitor.getNetworkTraffic();
print('接收: ${networkTraffic.receivedMB.toStringAsFixed(2)} MB');
print('发送: ${networkTraffic.sentMB.toStringAsFixed(2)} MB');
print('下载速率: ${networkTraffic.receiveRateMBps.toStringAsFixed(2)} MB/s');
print('上传速率: ${networkTraffic.sendRateMBps.toStringAsFixed(2)} MB/s');
```

### 使用监控流

```dart
final monitor = SystemMonitor();

// 创建每秒更新的监控流
final stream = monitor.createMonitorStream(
  interval: Duration(seconds: 1),
);

// 监听系统信息更新
stream.listen((systemInfo) {
  print('CPU: ${systemInfo.cpu.usage.toStringAsFixed(1)}%');
  print('内存: ${systemInfo.memory.usagePercentage.toStringAsFixed(1)}%');
});
```

### 监听电池状态变化

```dart
final monitor = SystemMonitor();

// 监听电池状态流
monitor.batteryStream.listen((batteryInfo) {
  print('电量变化: ${batteryInfo.level}%');
  print('充电状态: ${batteryInfo.isCharging}');
});
```

### 错误处理

```dart
try {
  final monitor = SystemMonitor();
  final systemInfo = await monitor.getSystemInfo();
  // 使用 systemInfo
} catch (e) {
  print('获取系统信息失败: $e');
}
```

### 在 Widget 中使用

```dart
class SystemMonitorWidget extends StatefulWidget {
  @override
  State<SystemMonitorWidget> createState() => _SystemMonitorWidgetState();
}

class _SystemMonitorWidgetState extends State<SystemMonitorWidget> {
  final _monitor = SystemMonitor();
  SystemInfo? _systemInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
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
      // 处理错误
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    }
    
    return Column(
      children: [
        Text('CPU: ${_systemInfo?.cpu.usage.toStringAsFixed(1)}%'),
        Text('内存: ${_systemInfo?.memory.totalMemoryGB.toStringAsFixed(2)} GB'),
        Text('电池: ${_systemInfo?.battery.level}%'),
      ],
    );
  }
}
```

---

## 平台支持

| 平台 | 状态 | 说明 |
|------|------|------|
| Windows | ✅ 完全支持 | Windows 10+ |
| Android | ✅ 完全支持 | API 21+ |
| iOS | 🚧 计划中 | 未来版本 |
| Linux | 🚧 计划中 | 未来版本 |
| macOS | 🚧 计划中 | 未来版本 |
| Web | ❌ 不支持 | 浏览器限制 |

---

## 性能提示

### 1. 使用单例模式

```dart
// SystemMonitor 已经是单例，直接使用
final monitor = SystemMonitor();
```

### 2. 批量获取

```dart
// 一次获取所有信息比多次调用更高效
final systemInfo = await monitor.getSystemInfo();

// 而不是
final cpuInfo = await monitor.getCpuInfo();
final memoryInfo = await monitor.getMemoryInfo();
final diskInfo = await monitor.getDiskInfo();
// ...
```

### 3. 使用流式监控

```dart
// 使用流式监控代替轮询
final stream = monitor.createMonitorStream(
  interval: Duration(seconds: 1),
);

stream.listen((systemInfo) {
  // 自动更新
});
```

---

## 常见问题

### Q: 如何实时监控系统状态？

```dart
final monitor = SystemMonitor();
final stream = monitor.createMonitorStream(
  interval: Duration(seconds: 1),
);

stream.listen((systemInfo) {
  print('CPU: ${systemInfo.cpu.usage}%');
  print('内存: ${systemInfo.memory.usagePercentage}%');
});
```

### Q: 如何获取 GB 单位的内存大小？

```dart
final memoryInfo = await monitor.getMemoryInfo();
final totalGB = memoryInfo.totalMemoryGB; // 自动转换为 GB
```

### Q: 如何监听电池状态变化？

```dart
final monitor = SystemMonitor();
monitor.batteryStream.listen((batteryInfo) {
  print('电量: ${batteryInfo.level}%');
});
```

### Q: 如何在不同平台显示不同内容？

```dart
import 'dart:io';

if (Platform.isWindows) {
  // Windows 特定代码
} else if (Platform.isAndroid) {
  // Android 特定代码
}
```

---

## 相关链接

- [完整 API 文档](API.md)
- [架构设计](ARCHITECTURE.md)
- [代码风格指南](CODE_STYLE.md)
- [贡献指南](../CONTRIBUTING.md)
- [GitHub 仓库](https://github.com/h1s97x/SystemMonitorKit)

---

**文档版本**: 1.0  
**创建日期**: 2026-03-08  
**项目**: system_monitor_kit
