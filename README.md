# System Monitor Kit

一个功能全面的 Flutter 系统监控工具包，提供 CPU、内存、磁盘、电池和网络流量的实时监控功能。

## 功能特性

- ✅ **CPU 监控**: CPU 使用率、核心数、架构信息
- ✅ **内存监控**: 总内存、已用内存、可用内存、使用率
- ✅ **磁盘监控**: 总空间、已用空间、可用空间、使用率
- ✅ **电池监控**: 电量、充电状态、低电量模式
- ✅ **网络流量**: 接收/发送字节数、实时速率
- ✅ **实时监控流**: 定时获取系统信息
- ✅ **跨平台支持**: Android、iOS、Windows、Linux、macOS

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  system_monitor_kit: ^1.0.0
```

运行：

```bash
flutter pub get
```

## 快速开始

### 1. 获取电池信息

```dart
import 'package:system_monitor_kit/system_monitor_kit.dart';

final monitor = SystemMonitor();

// 获取电池信息
final battery = await monitor.getBatteryInfo();
print('电池电量: ${battery.level}%');
print('充电状态: ${battery.state}');
print('是否充电: ${battery.isCharging}');
print('低电量: ${battery.isLowBattery}');
```

### 2. 获取 CPU 信息

```dart
final cpu = await monitor.getCpuInfo();
print('CPU 使用率: ${cpu.usage.toStringAsFixed(1)}%');
print('CPU 核心数: ${cpu.coreCount}');
print('CPU 架构: ${cpu.architecture}');
```

### 3. 获取内存信息

```dart
final memory = await monitor.getMemoryInfo();
print('总内存: ${memory.totalMemoryGB.toStringAsFixed(2)} GB');
print('已用内存: ${memory.usedMemoryGB.toStringAsFixed(2)} GB');
print('可用内存: ${memory.freeMemoryGB.toStringAsFixed(2)} GB');
print('使用率: ${memory.usage.toStringAsFixed(1)}%');
```

### 4. 获取磁盘信息

```dart
final disk = await monitor.getDiskInfo();
print('总空间: ${disk.totalSpaceGB.toStringAsFixed(2)} GB');
print('已用空间: ${disk.usedSpaceGB.toStringAsFixed(2)} GB');
print('可用空间: ${disk.freeSpaceGB.toStringAsFixed(2)} GB');
print('使用率: ${disk.usage.toStringAsFixed(1)}%');
```

### 5. 获取网络流量

```dart
final network = await monitor.getNetworkTraffic();
print('接收: ${network.receivedMB.toStringAsFixed(2)} MB');
print('发送: ${network.sentMB.toStringAsFixed(2)} MB');
print('下载速率: ${network.receiveRateKBps.toStringAsFixed(1)} KB/s');
print('上传速率: ${network.sendRateKBps.toStringAsFixed(1)} KB/s');
```

### 6. 获取系统综合信息

```dart
final system = await monitor.getSystemInfo();
print('CPU: ${system.cpu}');
print('内存: ${system.memory}');
print('磁盘: ${system.disk}');
print('电池: ${system.battery}');
print('网络: ${system.network}');
```

### 7. 实时监控流

```dart
// 每秒更新一次
monitor.createMonitorStream(
  interval: Duration(seconds: 1),
).listen((system) {
  print('CPU: ${system.cpu?.usage.toStringAsFixed(1)}%');
  print('内存: ${system.memory?.usage.toStringAsFixed(1)}%');
  print('电池: ${system.battery?.level}%');
});

// 监听电池状态变化
monitor.batteryStream.listen((battery) {
  print('电池状态变化: ${battery.level}% - ${battery.state}');
});
```

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:system_monitor_kit/system_monitor_kit.dart';

class SystemMonitorPage extends StatefulWidget {
  @override
  _SystemMonitorPageState createState() => _SystemMonitorPageState();
}

class _SystemMonitorPageState extends State<SystemMonitorPage> {
  final _monitor = SystemMonitor();
  SystemInfo? _systemInfo;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _monitor.createMonitorStream(
      interval: Duration(seconds: 2),
    ).listen((info) {
      setState(() => _systemInfo = info);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_systemInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildCard('CPU', [
          '使用率: ${_systemInfo!.cpu?.usage.toStringAsFixed(1)}%',
          '核心数: ${_systemInfo!.cpu?.coreCount}',
        ]),
        _buildCard('内存', [
          '使用率: ${_systemInfo!.memory?.usage.toStringAsFixed(1)}%',
          '已用: ${_systemInfo!.memory?.usedMemoryGB.toStringAsFixed(2)} GB',
          '可用: ${_systemInfo!.memory?.freeMemoryGB.toStringAsFixed(2)} GB',
        ]),
        _buildCard('磁盘', [
          '使用率: ${_systemInfo!.disk?.usage.toStringAsFixed(1)}%',
          '已用: ${_systemInfo!.disk?.usedSpaceGB.toStringAsFixed(2)} GB',
          '可用: ${_systemInfo!.disk?.freeSpaceGB.toStringAsFixed(2)} GB',
        ]),
        _buildCard('电池', [
          '电量: ${_systemInfo!.battery?.level}%',
          '状态: ${_systemInfo!.battery?.state.name}',
          '充电: ${_systemInfo!.battery?.isCharging}',
        ]),
        _buildCard('网络', [
          '下载: ${_systemInfo!.network?.receiveRateKBps.toStringAsFixed(1)} KB/s',
          '上传: ${_systemInfo!.network?.sendRateKBps.toStringAsFixed(1)} KB/s',
        ]),
      ],
    );
  }

  Widget _buildCard(String title, List<String> items) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...items.map((item) => Text(item)),
          ],
        ),
      ),
    );
  }
}
```

## API 文档

### SystemMonitor

主要的系统监控类，提供所有监控功能。

#### 方法

- `getBatteryInfo()` - 获取电池信息
- `getCpuInfo()` - 获取 CPU 信息
- `getMemoryInfo()` - 获取内存信息
- `getDiskInfo()` - 获取磁盘信息
- `getNetworkTraffic()` - 获取网络流量
- `getSystemInfo()` - 获取系统综合信息
- `createMonitorStream({interval})` - 创建实时监控流
- `batteryStream` - 电池状态变化流

### 数据模型

#### BatteryInfo
- `level` - 电池电量 (0-100)
- `state` - 电池状态 (charging/discharging/full/unknown)
- `isCharging` - 是否正在充电
- `isLowBattery` - 是否低电量 (< 20%)
- `isCriticalBattery` - 是否极低电量 (< 10%)

#### CpuInfo
- `usage` - CPU 使用率 (0-100)
- `coreCount` - CPU 核心数
- `architecture` - CPU 架构

#### MemoryInfo
- `totalMemory` - 总内存 (bytes)
- `usedMemory` - 已用内存 (bytes)
- `freeMemory` - 可用内存 (bytes)
- `usage` - 使用率 (0-100)
- `totalMemoryGB/MB` - 总内存 (GB/MB)
- `usedMemoryGB/MB` - 已用内存 (GB/MB)
- `freeMemoryGB/MB` - 可用内存 (GB/MB)

#### DiskInfo
- `totalSpace` - 总空间 (bytes)
- `usedSpace` - 已用空间 (bytes)
- `freeSpace` - 可用空间 (bytes)
- `usage` - 使用率 (0-100)
- `totalSpaceGB/MB` - 总空间 (GB/MB)
- `usedSpaceGB/MB` - 已用空间 (GB/MB)
- `freeSpaceGB/MB` - 可用空间 (GB/MB)

#### NetworkTraffic
- `receivedBytes` - 接收字节数
- `sentBytes` - 发送字节数
- `receiveRate` - 接收速率 (bytes/s)
- `sendRate` - 发送速率 (bytes/s)
- `receivedMB/sentMB` - 接收/发送流量 (MB)
- `receiveRateKBps/sendRateKBps` - 速率 (KB/s)

## 平台支持

| 平台 | CPU | 内存 | 磁盘 | 电池 | 网络 |
|------|-----|------|------|------|------|
| Android | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| iOS | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Windows | ✅ | ⚠️ | ✅ | ❌ | ⚠️ |
| Linux | ✅ | ⚠️ | ✅ | ❌ | ⚠️ |
| macOS | ✅ | ⚠️ | ✅ | ✅ | ⚠️ |

- ✅ 完全支持
- ⚠️ 部分支持或使用估算值
- ❌ 不支持

## 注意事项

1. **权限要求**: 某些平台可能需要特定权限才能访问系统信息
2. **精确度**: CPU 和内存使用率在某些平台上使用估算值
3. **性能**: 频繁监控可能影响应用性能，建议使用合理的更新间隔
4. **电池**: 桌面平台可能不支持电池信息

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 相关链接

- [GitHub](https://github.com/h1s97x/SystemMonitorKit)
- [问题反馈](https://github.com/h1s97x/SystemMonitorKit/issues)
