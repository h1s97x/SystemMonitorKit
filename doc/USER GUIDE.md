# Getting Started with System Monitor Kit

本指南将帮助你快速开始使用 System Monitor Kit。

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

## 基础使用

### 1. 导入包

```dart
import 'package:system_monitor_kit/system_monitor_kit.dart';
```

### 2. 创建监控实例

```dart
final monitor = SystemMonitor();
```

`SystemMonitor` 使用单例模式，你可以在应用的任何地方访问同一个实例。

### 3. 获取电池信息

```dart
final battery = await monitor.getBatteryInfo();

print('电池电量: ${battery.level}%');
print('充电状态: ${battery.state.name}');
print('是否充电: ${battery.isCharging}');
print('低电量: ${battery.isLowBattery}'); // < 20%
print('极低电量: ${battery.isCriticalBattery}'); // < 10%
print('省电模式: ${battery.isInBatterySaveMode}');
```

### 4. 获取 CPU 信息

```dart
final cpu = await monitor.getCpuInfo();

print('CPU 使用率: ${cpu.usage.toStringAsFixed(1)}%');
print('CPU 核心数: ${cpu.coreCount}');
print('CPU 架构: ${cpu.architecture}');
```

### 5. 获取内存信息

```dart
final memory = await monitor.getMemoryInfo();

// 使用 GB 单位
print('总内存: ${memory.totalMemoryGB.toStringAsFixed(2)} GB');
print('已用内存: ${memory.usedMemoryGB.toStringAsFixed(2)} GB');
print('可用内存: ${memory.freeMemoryGB.toStringAsFixed(2)} GB');

// 使用 MB 单位
print('总内存: ${memory.totalMemoryMB.toStringAsFixed(0)} MB');

// 使用率
print('内存使用率: ${memory.usage.toStringAsFixed(1)}%');
```

### 6. 获取磁盘信息

```dart
final disk = await monitor.getDiskInfo();

print('总空间: ${disk.totalSpaceGB.toStringAsFixed(2)} GB');
print('已用空间: ${disk.usedSpaceGB.toStringAsFixed(2)} GB');
print('可用空间: ${disk.freeSpaceGB.toStringAsFixed(2)} GB');
print('使用率: ${disk.usage.toStringAsFixed(1)}%');
```

### 7. 获取网络流量

```dart
final network = await monitor.getNetworkTraffic();

// 流量统计
print('已接收: ${network.receivedMB.toStringAsFixed(2)} MB');
print('已发送: ${network.sentMB.toStringAsFixed(2)} MB');
print('总流量: ${network.totalMB.toStringAsFixed(2)} MB');

// 实时速率
print('下载速率: ${network.receiveRateKBps.toStringAsFixed(1)} KB/s');
print('上传速率: ${network.sendRateKBps.toStringAsFixed(1)} KB/s');
```

### 8. 获取系统综合信息

```dart
final system = await monitor.getSystemInfo();

// 访问各个组件
print('CPU: ${system.cpu}');
print('内存: ${system.memory}');
print('磁盘: ${system.disk}');
print('电池: ${system.battery}');
print('网络: ${system.network}');
print('采样时间: ${system.timestamp}');
```

## 实时监控

### 创建监控流

```dart
// 每秒更新一次
final stream = monitor.createMonitorStream(
  interval: Duration(seconds: 1),
);

stream.listen((system) {
  print('CPU: ${system.cpu?.usage.toStringAsFixed(1)}%');
  print('内存: ${system.memory?.usage.toStringAsFixed(1)}%');
  print('电池: ${system.battery?.level}%');
});
```

### 监听电池状态变化

```dart
monitor.batteryStream.listen((battery) {
  print('电池状态变化:');
  print('  电量: ${battery.level}%');
  print('  状态: ${battery.state.name}');
  
  if (battery.isLowBattery) {
    print('  警告: 电量低！');
  }
});
```

## 在 Flutter Widget 中使用

### StatefulWidget 示例

```dart
class SystemMonitorWidget extends StatefulWidget {
  @override
  _SystemMonitorWidgetState createState() => _SystemMonitorWidgetState();
}

class _SystemMonitorWidgetState extends State<SystemMonitorWidget> {
  final _monitor = SystemMonitor();
  SystemInfo? _systemInfo;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = _monitor.createMonitorStream(
      interval: Duration(seconds: 2),
    ).listen((info) {
      setState(() => _systemInfo = info);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_systemInfo == null) {
      return CircularProgressIndicator();
    }

    return Column(
      children: [
        Text('CPU: ${_systemInfo!.cpu?.usage.toStringAsFixed(1)}%'),
        Text('内存: ${_systemInfo!.memory?.usage.toStringAsFixed(1)}%'),
        Text('电池: ${_systemInfo!.battery?.level}%'),
      ],
    );
  }
}
```

### 使用 StreamBuilder

```dart
class SystemMonitorStreamWidget extends StatelessWidget {
  final _monitor = SystemMonitor();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SystemInfo>(
      stream: _monitor.createMonitorStream(
        interval: Duration(seconds: 2),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final system = snapshot.data!;
        return Column(
          children: [
            Text('CPU: ${system.cpu?.usage.toStringAsFixed(1)}%'),
            Text('内存: ${system.memory?.usage.toStringAsFixed(1)}%'),
            Text('电池: ${system.battery?.level}%'),
          ],
        );
      },
    );
  }
}
```

## 数据模型详解

### BatteryInfo

```dart
class BatteryInfo {
  final int level;                    // 电量 (0-100)
  final BatteryState state;           // 状态
  final bool isCharging;              // 是否充电
  final bool isInBatterySaveMode;     // 省电模式
  final DateTime timestamp;           // 采样时间
  
  bool get isLowBattery;              // < 20%
  bool get isCriticalBattery;         // < 10%
}

enum BatteryState {
  charging,      // 充电中
  discharging,   // 放电中
  full,          // 已充满
  unknown,       // 未知
}
```

### CpuInfo

```dart
class CpuInfo {
  final double usage;          // 使用率 (0-100)
  final int coreCount;         // 核心数
  final String? architecture;  // 架构 (ARM, x86_64)
  final double? frequency;     // 频率 (MHz)
  final DateTime timestamp;    // 采样时间
}
```

### MemoryInfo

```dart
class MemoryInfo {
  final int totalMemory;       // 总内存 (bytes)
  final int usedMemory;        // 已用内存 (bytes)
  final int freeMemory;        // 可用内存 (bytes)
  final double usage;          // 使用率 (0-100)
  final DateTime timestamp;    // 采样时间
  
  // 便捷属性
  double get totalMemoryGB;
  double get usedMemoryGB;
  double get freeMemoryGB;
  double get totalMemoryMB;
  double get usedMemoryMB;
  double get freeMemoryMB;
}
```

### DiskInfo

```dart
class DiskInfo {
  final int totalSpace;        // 总空间 (bytes)
  final int usedSpace;         // 已用空间 (bytes)
  final int freeSpace;         // 可用空间 (bytes)
  final double usage;          // 使用率 (0-100)
  final DateTime timestamp;    // 采样时间
  
  // 便捷属性
  double get totalSpaceGB;
  double get usedSpaceGB;
  double get freeSpaceGB;
  double get totalSpaceMB;
  double get usedSpaceMB;
  double get freeSpaceMB;
}
```

### NetworkTraffic

```dart
class NetworkTraffic {
  final int receivedBytes;     // 接收字节数
  final int sentBytes;         // 发送字节数
  final double receiveRate;    // 接收速率 (bytes/s)
  final double sendRate;       // 发送速率 (bytes/s)
  final DateTime timestamp;    // 采样时间
  
  // 便捷属性
  double get receivedMB;
  double get sentMB;
  double get totalMB;
  double get receiveRateKBps;
  double get sendRateKBps;
  double get receiveRateMBps;
  double get sendRateMBps;
}
```

## 最佳实践

### 1. 合理的更新间隔

```dart
// 实时监控 - 1秒
monitor.createMonitorStream(interval: Duration(seconds: 1));

// 常规监控 - 2-5秒
monitor.createMonitorStream(interval: Duration(seconds: 3));

// 后台监控 - 10-30秒
monitor.createMonitorStream(interval: Duration(seconds: 15));
```

### 2. 及时取消订阅

```dart
StreamSubscription? _subscription;

void startMonitoring() {
  _subscription = monitor.createMonitorStream().listen(...);
}

void stopMonitoring() {
  _subscription?.cancel();
  _subscription = null;
}

@override
void dispose() {
  stopMonitoring();
  super.dispose();
}
```

### 3. 错误处理

```dart
try {
  final system = await monitor.getSystemInfo();
  // 使用数据
} catch (e) {
  print('获取系统信息失败: $e');
  // 显示错误或使用默认值
}
```

### 4. 条件监控

```dart
// 只在电量低时监控
monitor.batteryStream.listen((battery) {
  if (battery.isLowBattery) {
    // 启动省电措施
    print('电量低，启动省电模式');
  }
});

// 只在内存不足时监控
final memory = await monitor.getMemoryInfo();
if (memory.usage > 80) {
  print('内存使用率过高: ${memory.usage.toStringAsFixed(1)}%');
  // 清理缓存
}
```

## 故障排除

### 电池信息获取失败

某些桌面平台可能不支持电池信息：

```dart
final battery = await monitor.getBatteryInfo();
if (battery.state == BatteryState.unknown) {
  print('此设备不支持电池信息');
}
```

### 磁盘空间为 0

确保应用有访问存储的权限：

```dart
final disk = await monitor.getDiskInfo();
if (disk.totalSpace == 0) {
  print('无法获取磁盘信息，请检查权限');
}
```

### 监控流不更新

确保 Widget 仍然 mounted：

```dart
stream.listen((system) {
  if (mounted) {
    setState(() => _systemInfo = system);
  }
});
```

## 下一步

- 查看 [README.md](README.md) 了解更多功能
- 运行 [example](example/) 查看完整示例
- 查看 [CHANGELOG.md](CHANGELOG.md) 了解版本历史

## 支持

如有问题或建议，请访问：
- GitHub Issues: https://github.com/h1s97x/SystemMonitorKit/issues
- 文档: https://github.com/h1s97x/SystemMonitorKit
