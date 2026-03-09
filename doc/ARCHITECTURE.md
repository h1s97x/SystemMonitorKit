# system_monitor_kit 架构设计

本文档描述 system_monitor_kit 项目的架构设计原则和实现方案。

## 目录

1. [设计原则](#设计原则)
2. [目录结构](#目录结构)
3. [模块划分](#模块划分)
4. [平台实现](#平台实现)
5. [扩展指南](#扩展指南)

---

## 设计原则

### 1. 简单易用

提供简单直观的 API，开发者可以快速集成和使用。

**优势**:
- 快速上手
- 减少学习成本
- 降低出错概率

**示例**:

```dart
// 创建监控器实例（单例模式）
final monitor = SystemMonitor();

// 一行代码获取所有系统信息
final systemInfo = await monitor.getSystemInfo();
```

### 2. 跨平台一致性

所有平台提供统一的 API 接口，返回相同的数据结构。

**实现**:
- 统一的 Dart API 层
- 统一的数据模型
- 平台特定的实现细节被封装

### 3. 类型安全

使用强类型的数据模型，避免运行时错误。

**实现**:
- 所有数据模型都有明确的类型定义
- 使用可空类型处理可能缺失的数据
- 提供便捷的 getter 方法（如 GB/MB 转换）

### 4. 异步非阻塞

所有 API 都是异步的，不会阻塞 UI 线程。

**实现**:
- 使用 `Future` 返回结果
- 使用 `Stream` 提供实时监控
- 平台代码在后台线程执行

### 5. 可扩展性

易于添加新的监控功能和新的平台支持。

**实现**:
- 模块化的代码结构
- 清晰的接口定义
- 详细的扩展文档

---

## 目录结构

```
system_monitor_kit/
├── lib/                                    # Dart 代码
│   ├── system_monitor_kit.dart            # 主导出文件
│   ├── system_monitor_kit_method_channel.dart
│   ├── system_monitor_kit_platform_interface.dart
│   └── src/
│       ├── system_monitor.dart            # 核心 API 实现
│       └── models/                        # 数据模型
│           ├── models.dart                # 模型导出文件
│           ├── system_info.dart
│           ├── cpu_info.dart
│           ├── memory_info.dart
│           ├── disk_info.dart
│           ├── battery_info.dart
│           └── network_traffic.dart
├── android/                               # Android 平台实现
│   └── src/main/kotlin/.../
│       └── SystemMonitorKitPlugin.kt      # Kotlin 实现
├── windows/                               # Windows 平台实现
│   ├── system_monitor_kit_plugin.cpp      # 插件接口
│   └── CMakeLists.txt
├── test/                                  # 单元测试
├── example/                               # 示例应用
├── benchmark/                             # 性能测试
└── doc/                                   # 文档
```

---

## 模块划分

### Dart API 层

**职责**:
- 提供公共 API 接口
- 处理平台通信
- 数据模型的序列化和反序列化
- 异常处理

**核心类**:

#### SystemMonitor

主 API 类，提供所有系统监控方法。使用单例模式。

```dart
class SystemMonitor {
  // 单例实例
  static final SystemMonitor _instance = SystemMonitor._internal();
  factory SystemMonitor() => _instance;
  
  // 获取系统信息
  Future<SystemInfo> getSystemInfo();
  Future<CpuInfo> getCpuInfo();
  Future<MemoryInfo> getMemoryInfo();
  Future<DiskInfo> getDiskInfo();
  Future<BatteryInfo> getBatteryInfo();
  Future<NetworkTraffic> getNetworkTraffic();
  
  // 实时监控
  Stream<SystemInfo> createMonitorStream({Duration interval});
  Stream<BatteryInfo> get batteryStream;
}
```

### 数据模型层

**职责**:
- 定义系统监控信息的数据结构
- 提供 JSON 序列化/反序列化
- 提供便捷的 getter 方法

**核心模型**:

#### SystemInfo
完整的系统信息，包含所有监控数据。

#### CpuInfo
CPU 信息：使用率、核心数、架构、频率等。

#### MemoryInfo
内存信息：总量、已用、可用、使用率等。

#### DiskInfo
磁盘信息：总空间、已用空间、可用空间、使用率等。

#### BatteryInfo
电池信息：电量、充电状态、省电模式等。

#### NetworkTraffic
网络流量：接收/发送字节数、速率等。

---

## 平台实现

### 依赖的第三方包

system_monitor_kit 使用以下第三方包来实现跨平台功能：

#### battery_plus

用于获取电池信息。

**功能**:
- 电池电量
- 充电状态
- 省电模式
- 电池状态变化流

**使用**:

```dart
final _battery = bp.Battery();
final level = await _battery.batteryLevel;
final state = await _battery.batteryState;
```

#### disk_space_plus

用于获取磁盘空间信息。

**功能**:
- 总磁盘空间
- 可用磁盘空间

**使用**:

```dart
final diskSpace = DiskSpacePlus();
final totalSpace = await diskSpace.getTotalDiskSpace;
final freeSpace = await diskSpace.getFreeDiskSpace;
```

#### device_info_plus

用于获取设备信息（未来可能使用）。

### 平台特定实现

#### CPU 信息

```dart
// 核心数
final coreCount = Platform.numberOfProcessors;

// 架构
String? _getCpuArchitecture() {
  if (Platform.isAndroid || Platform.isIOS) {
    return 'ARM';
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return 'x86_64';
  }
  return null;
}
```

#### 内存信息

当前使用估算值，未来版本将实现平台特定的原生代码。

```dart
Future<int> _estimateTotalMemory() async {
  if (Platform.isAndroid || Platform.isIOS) {
    return 8 * 1024 * 1024 * 1024; // 8GB
  } else {
    return 16 * 1024 * 1024 * 1024; // 16GB
  }
}
```

#### 网络流量

当前使用模拟值，未来版本将实现平台特定的原生代码。

---

## 数据流

```
┌─────────────┐
│   Flutter   │
│     App     │
└──────┬──────┘
       │
       │ 调用 API
       ▼
┌─────────────────┐
│ SystemMonitor   │
│   (Dart API)    │
└──────┬──────────┘
       │
       │ 使用第三方包
       ▼
┌─────────────────┐
│  battery_plus   │
│ disk_space_plus │
│device_info_plus │
└──────┬──────────┘
       │
       │ 平台通道
       ▼
┌─────────────────┐
│  Platform Code  │
│ (Kotlin / Swift)│
└──────┬──────────┘
       │
       │ 系统 API
       ▼
┌─────────────────┐
│  Operating      │
│    System       │
└─────────────────┘
```

---

## 扩展指南

### 添加新的监控功能

假设要添加 "温度监控"：

#### 步骤 1: 创建数据模型

在 `lib/src/models/` 创建 `temperature_info.dart`:

```dart
/// 温度信息
class TemperatureInfo {
  /// CPU 温度 (摄氏度)
  final double? cpuTemperature;
  
  /// GPU 温度 (摄氏度)
  final double? gpuTemperature;
  
  /// 电池温度 (摄氏度)
  final double? batteryTemperature;
  
  /// 采样时间
  final DateTime timestamp;

  TemperatureInfo({
    this.cpuTemperature,
    this.gpuTemperature,
    this.batteryTemperature,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'cpuTemperature': cpuTemperature,
      'gpuTemperature': gpuTemperature,
      'batteryTemperature': batteryTemperature,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    return TemperatureInfo(
      cpuTemperature: json['cpuTemperature'] as double?,
      gpuTemperature: json['gpuTemperature'] as double?,
      batteryTemperature: json['batteryTemperature'] as double?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() {
    return 'TemperatureInfo(cpu: $cpuTemperature°C, gpu: $gpuTemperature°C)';
  }
}
```

#### 步骤 2: 添加到 SystemInfo

在 `lib/src/models/system_info.dart` 添加:

```dart
class SystemInfo {
  final CpuInfo? cpu;
  final MemoryInfo? memory;
  final DiskInfo? disk;
  final BatteryInfo? battery;
  final NetworkTraffic? network;
  final TemperatureInfo? temperature;  // 新增
  final DateTime timestamp;

  SystemInfo({
    this.cpu,
    this.memory,
    this.disk,
    this.battery,
    this.network,
    this.temperature,  // 新增
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
```

#### 步骤 3: 添加 API 方法

在 `lib/src/system_monitor.dart` 添加:

```dart
/// 获取温度信息
Future<TemperatureInfo> getTemperatureInfo() async {
  try {
    // 实现温度获取逻辑
    // 可能需要使用平台特定的原生代码
    
    return TemperatureInfo(
      cpuTemperature: 45.0,
      gpuTemperature: 50.0,
      batteryTemperature: 35.0,
    );
  } catch (e) {
    debugPrint('Failed to get temperature info: $e');
    return TemperatureInfo();
  }
}
```

#### 步骤 4: 更新 getSystemInfo

```dart
Future<SystemInfo> getSystemInfo() async {
  try {
    final results = await Future.wait([
      getCpuInfo(),
      getMemoryInfo(),
      getDiskInfo(),
      getBatteryInfo(),
      getNetworkTraffic(),
      getTemperatureInfo(),  // 新增
    ]);

    return SystemInfo(
      cpu: results[0] as CpuInfo,
      memory: results[1] as MemoryInfo,
      disk: results[2] as DiskInfo,
      battery: results[3] as BatteryInfo,
      network: results[4] as NetworkTraffic,
      temperature: results[5] as TemperatureInfo,  // 新增
    );
  } catch (e) {
    debugPrint('Failed to get system info: $e');
    return SystemInfo();
  }
}
```

#### 步骤 5: 添加测试

在 `test/` 目录添加测试文件。

#### 步骤 6: 更新文档

更新 README.md 和 API.md 文档。

### 实现平台特定的原生代码

对于需要原生实现的功能（如真实的 CPU 使用率、内存信息等），可以：

1. 在 `android/` 目录实现 Kotlin 代码
2. 在 `ios/` 目录实现 Swift 代码
3. 在 `windows/` 目录实现 C++ 代码
4. 使用 MethodChannel 与 Dart 通信

---

## 性能优化

### 1. 单例模式

SystemMonitor 使用单例模式，避免重复创建实例：

```dart
class SystemMonitor {
  static final SystemMonitor _instance = SystemMonitor._internal();
  factory SystemMonitor() => _instance;
  SystemMonitor._internal();
}
```

### 2. 批量获取

使用 `getSystemInfo()` 一次性获取所有信息，比多次调用单个方法更高效：

```dart
// 推荐
final systemInfo = await monitor.getSystemInfo();

// 不推荐
final cpuInfo = await monitor.getCpuInfo();
final memoryInfo = await monitor.getMemoryInfo();
final diskInfo = await monitor.getDiskInfo();
// ...
```

### 3. 使用流式监控

使用 `createMonitorStream()` 代替轮询：

```dart
// 推荐
final stream = monitor.createMonitorStream(
  interval: Duration(seconds: 1),
);
stream.listen((systemInfo) {
  // 自动更新
});

// 不推荐
Timer.periodic(Duration(seconds: 1), (_) async {
  final systemInfo = await monitor.getSystemInfo();
  // 手动更新
});
```

### 4. 合理的更新间隔

根据使用场景选择合适的更新间隔：

```dart
// 实时监控 - 1秒
monitor.createMonitorStream(interval: Duration(seconds: 1));

// 常规监控 - 2-5秒
monitor.createMonitorStream(interval: Duration(seconds: 3));

// 后台监控 - 10-30秒
monitor.createMonitorStream(interval: Duration(seconds: 15));
```

---

## 错误处理

### 异常处理策略

1. **捕获异常**: 所有方法都捕获异常并返回默认值
2. **日志记录**: 使用 `debugPrint` 记录错误信息
3. **优雅降级**: 返回安全的默认值而不是抛出异常

**示例**:

```dart
Future<CpuInfo> getCpuInfo() async {
  try {
    // 获取 CPU 信息
    return CpuInfo(...);
  } catch (e) {
    debugPrint('Failed to get CPU info: $e');
    return CpuInfo(
      usage: 0,
      coreCount: Platform.numberOfProcessors,
    );
  }
}
```

---

## 测试策略

### 单元测试

测试数据模型的序列化和反序列化：

```dart
test('CpuInfo.fromJson 正确解析数据', () {
  final json = {
    'usage': 50.0,
    'coreCount': 8,
    'architecture': 'x86_64',
    'timestamp': DateTime.now().toIso8601String(),
  };
  final cpuInfo = CpuInfo.fromJson(json);
  
  expect(cpuInfo.usage, 50.0);
  expect(cpuInfo.coreCount, 8);
  expect(cpuInfo.architecture, 'x86_64');
});
```

### 集成测试

测试实际的系统信息获取：

```dart
testWidgets('getSystemInfo 返回有效数据', (tester) async {
  final monitor = SystemMonitor();
  final systemInfo = await monitor.getSystemInfo();
  
  expect(systemInfo, isNotNull);
  expect(systemInfo.cpu, isNotNull);
  expect(systemInfo.memory, isNotNull);
});
```

### 性能测试

使用 benchmark 测试性能：

```dart
void main() {
  benchmark('getSystemInfo', () async {
    final monitor = SystemMonitor();
    await monitor.getSystemInfo();
  });
}
```

---

## 最佳实践

### 1. 使用单例

```dart
// 推荐
final monitor = SystemMonitor();

// 不推荐
final monitor1 = SystemMonitor();
final monitor2 = SystemMonitor();
```

### 2. 处理可空值

```dart
// 推荐
final cpuUsage = systemInfo.cpu?.usage ?? 0;
print('CPU: ${cpuUsage.toStringAsFixed(1)}%');

// 不推荐
print('CPU: ${systemInfo.cpu!.usage.toStringAsFixed(1)}%');  // 可能崩溃
```

### 3. 使用便捷 getter

```dart
// 推荐
print('内存: ${memoryInfo.totalMemoryGB.toStringAsFixed(2)} GB');

// 不推荐
print('内存: ${(memoryInfo.totalMemory / 1024 / 1024 / 1024).toStringAsFixed(2)} GB');
```

### 4. 及时取消订阅

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

---

## 总结

system_monitor_kit 的架构设计遵循以下原则：

1. **简单易用**: 提供直观的 API
2. **跨平台一致**: 统一的接口和数据结构
3. **类型安全**: 强类型的数据模型
4. **高性能**: 异步非阻塞调用
5. **可扩展**: 易于添加新功能

这种设计为项目的长期发展和维护奠定了坚实的基础。

---

**文档版本**: 1.0  
**创建日期**: 2026-03-09  
**项目**: system_monitor_kit
