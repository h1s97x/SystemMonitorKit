# system_monitor_kit 代码风格指南

本文档定义了 system_monitor_kit 项目的代码风格规范。

## 基本原则

1. **一致性**: 保持代码风格一致
2. **可读性**: 代码应该易于理解
3. **简洁性**: 避免不必要的复杂性
4. **可维护性**: 便于后续维护和扩展

---

## Dart 代码风格

### 命名规范

#### 文件命名

使用 `snake_case`（小写下划线）:

```
✅ 好的示例
cpu_info.dart
memory_info.dart
system_monitor.dart

❌ 不好的示例
CpuInfo.dart
cpuInfo.dart
CPU_Info.dart
```

#### 类命名

使用 `PascalCase`（大驼峰）:

```dart
✅ 好的示例
class CpuInfo {}
class MemoryInfo {}
class SystemMonitor {}

❌ 不好的示例
class cpuInfo {}
class cpu_info {}
class CPUINFO {}
```

#### 变量和方法命名

使用 `camelCase`（小驼峰）:

```dart
✅ 好的示例
final monitor = SystemMonitor();
final cpuInfo = await monitor.getCpuInfo();
final totalMemoryGB = memoryInfo.totalMemoryGB;

Future<CpuInfo> getCpuInfo() async { }

❌ 不好的示例
final Monitor = SystemMonitor();
final CPUInfo = await monitor.GetCPUInfo();
final TotalMemoryGB = memoryInfo.TotalMemoryGB;

Future<CpuInfo> GetCpuInfo() async { }
```

#### 常量命名

使用 `lowerCamelCase`:

```dart
✅ 好的示例
const defaultInterval = Duration(seconds: 1);
const maxRetries = 3;

❌ 不好的示例
const DEFAULT_INTERVAL = Duration(seconds: 1);
const MAX_RETRIES = 3;
```

### 代码格式

#### 缩进

使用 2 个空格缩进:

```dart
✅ 好的示例
class CpuInfo {
  final double usage;
  
  CpuInfo({required this.usage});
}

❌ 不好的示例
class CpuInfo {
    final double usage;  // 4 个空格
    
    CpuInfo({required this.usage});
}
```

#### 行长度

每行最多 80 个字符，超过时适当换行:

```dart
✅ 好的示例
final cpuInfo = CpuInfo(
  usage: 50.0,
  coreCount: 8,
  architecture: 'x86_64',
);

❌ 不好的示例
final cpuInfo = CpuInfo(usage: 50.0, coreCount: 8, architecture: 'x86_64', frequency: 3600.0);
```

#### 尾随逗号

多行参数列表使用尾随逗号:

```dart
✅ 好的示例
return CpuInfo(
  usage: usage,
  coreCount: coreCount,
  architecture: architecture,  // 尾随逗号
);

❌ 不好的示例
return CpuInfo(
  usage: usage,
  coreCount: coreCount,
  architecture: architecture  // 缺少尾随逗号
);
```

### 类型注解

#### 公共 API

必须显式声明返回类型和参数类型:

```dart
✅ 好的示例
Future<CpuInfo> getCpuInfo() async {
  // ...
}

❌ 不好的示例
getCpuInfo() async {
  // ...
}
```

#### 局部变量

可以使用类型推断:

```dart
✅ 好的示例
final monitor = SystemMonitor();
final cpuInfo = await monitor.getCpuInfo();
final usage = cpuInfo.usage;

✅ 也可以
final SystemMonitor monitor = SystemMonitor();
final CpuInfo cpuInfo = await monitor.getCpuInfo();
final double usage = cpuInfo.usage;
```

### 文档注释

#### 公共 API

所有公共类、方法、属性必须有文档注释:

```dart
✅ 好的示例
/// CPU/处理器信息
///
/// 包含 CPU 的使用率、核心数、架构等信息。
class CpuInfo {
  /// CPU 使用率 (0-100)
  ///
  /// 表示当前 CPU 的使用百分比。
  final double usage;
  
  /// 获取 CPU 信息
  ///
  /// 返回包含 CPU 详细信息的 [CpuInfo] 对象。
  ///
  /// 示例:
  /// ```dart
  /// final monitor = SystemMonitor();
  /// final cpuInfo = await monitor.getCpuInfo();
  /// print('CPU: ${cpuInfo.usage.toStringAsFixed(1)}%');
  /// ```
  Future<CpuInfo> getCpuInfo() async {
    // ...
  }
}
```

#### 私有成员

使用行内注释:

```dart
✅ 好的示例
// 估算 CPU 使用率
Future<double> _estimateCpuUsage() async {
  // 简单的估算算法
  await Future.delayed(const Duration(milliseconds: 100));
  return 25.0 + (DateTime.now().millisecond % 50);
}
```

### 构造函数顺序

构造函数必须在字段定义之前:

```dart
✅ 好的示例
class CpuInfo {
  CpuInfo({
    required this.usage,
    required this.coreCount,
  });
  
  factory CpuInfo.fromJson(Map<String, dynamic> json) {
    return CpuInfo(
      usage: (json['usage'] as num).toDouble(),
      coreCount: json['coreCount'] as int,
    );
  }
  
  final double usage;
  final int coreCount;
}

❌ 不好的示例
class CpuInfo {
  final double usage;
  final int coreCount;
  
  CpuInfo({
    required this.usage,
    required this.coreCount,
  });  // 应该在字段之前
}
```

---

## Kotlin 代码风格 (Android)

### 命名规范

#### 类命名

使用 `PascalCase`:

```kotlin
✅ 好的示例
class SystemMonitorKitPlugin : FlutterPlugin, MethodCallHandler {
}

❌ 不好的示例
class systemMonitorKitPlugin : FlutterPlugin {
}
```

#### 函数和变量命名

使用 `camelCase`:

```kotlin
✅ 好的示例
private fun getCpuInfo(): Map<String, Any?> {
  val coreCount = Runtime.getRuntime().availableProcessors()
  return mapOf("coreCount" to coreCount)
}

❌ 不好的示例
private fun GetCpuInfo(): Map<String, Any?> {
  val CoreCount = Runtime.getRuntime().availableProcessors()
}
```

### 代码格式

#### 缩进

使用 2 个空格:

```kotlin
✅ 好的示例
override fun onMethodCall(call: MethodCall, result: Result) {
  when (call.method) {
    "getCpuInfo" -> {
      result.success(getCpuInfo())
    }
  }
}
```

#### 使用 when 而不是 if-else 链

```kotlin
✅ 好的示例
when (call.method) {
  "getCpuInfo" -> result.success(getCpuInfo())
  "getMemoryInfo" -> result.success(getMemoryInfo())
  else -> result.notImplemented()
}

❌ 不好的示例
if (call.method == "getCpuInfo") {
  result.success(getCpuInfo())
} else if (call.method == "getMemoryInfo") {
  result.success(getMemoryInfo())
} else {
  result.notImplemented()
}
```

---

## 最佳实践

### 1. 使用 const

尽可能使用 `const`:

```dart
✅ 好的示例
const defaultInterval = Duration(seconds: 1);

❌ 不好的示例
final defaultInterval = Duration(seconds: 1);
```

### 2. 空安全

正确使用可空类型:

```dart
✅ 好的示例
final architecture = cpuInfo.architecture;
if (architecture != null) {
  print('架构: $architecture');
}

// 或使用 ?.
print('架构: ${cpuInfo.architecture ?? "未知"}');

❌ 不好的示例
final architecture = cpuInfo.architecture!;  // 可能崩溃
print('架构: $architecture');
```

### 3. 异步处理

使用 async/await:

```dart
✅ 好的示例
Future<CpuInfo> getCpuInfo() async {
  final coreCount = Platform.numberOfProcessors;
  final usage = await _estimateCpuUsage();
  return CpuInfo(usage: usage, coreCount: coreCount);
}

❌ 不好的示例
Future<CpuInfo> getCpuInfo() {
  return _estimateCpuUsage().then((usage) {
    final coreCount = Platform.numberOfProcessors;
    return CpuInfo(usage: usage, coreCount: coreCount);
  });
}
```

### 4. 错误处理

明确处理异常:

```dart
✅ 好的示例
Future<CpuInfo> getCpuInfo() async {
  try {
    final coreCount = Platform.numberOfProcessors;
    final usage = await _estimateCpuUsage();
    return CpuInfo(usage: usage, coreCount: coreCount);
  } catch (e) {
    debugPrint('Failed to get CPU info: $e');
    return CpuInfo(
      usage: 0,
      coreCount: Platform.numberOfProcessors,
    );
  }
}

❌ 不好的示例
Future<CpuInfo> getCpuInfo() async {
  final coreCount = Platform.numberOfProcessors;
  final usage = await _estimateCpuUsage();
  return CpuInfo(usage: usage, coreCount: coreCount);  // 未处理异常
}
```

### 5. 使用单例模式

```dart
✅ 好的示例
class SystemMonitor {
  static final SystemMonitor _instance = SystemMonitor._internal();
  factory SystemMonitor() => _instance;
  SystemMonitor._internal();
}

// 使用
final monitor = SystemMonitor();
```

### 6. 提供便捷 getter

```dart
✅ 好的示例
class MemoryInfo {
  final int totalMemory;  // bytes
  
  // 便捷 getter
  double get totalMemoryGB => totalMemory / (1024 * 1024 * 1024);
  double get totalMemoryMB => totalMemory / (1024 * 1024);
}

// 使用
print('内存: ${memoryInfo.totalMemoryGB.toStringAsFixed(2)} GB');
```

### 7. 使用命名参数

```dart
✅ 好的示例
class CpuInfo {
  CpuInfo({
    required this.usage,
    required this.coreCount,
    this.architecture,
    this.frequency,
  });
  
  final double usage;
  final int coreCount;
  final String? architecture;
  final double? frequency;
}

// 使用
final cpuInfo = CpuInfo(
  usage: 50.0,
  coreCount: 8,
  architecture: 'x86_64',
);

❌ 不好的示例
class CpuInfo {
  CpuInfo(this.usage, this.coreCount, this.architecture, this.frequency);
  
  final double usage;
  final int coreCount;
  final String? architecture;
  final double? frequency;
}

// 使用 - 不清楚每个参数的含义
final cpuInfo = CpuInfo(50.0, 8, 'x86_64', null);
```

---

## 工具

### 格式化

```bash
# 格式化所有文件
dart format .

# 检查格式（不修改）
dart format --output=none --set-exit-if-changed .
```

### 分析

```bash
# 运行代码分析
flutter analyze

# 修复可自动修复的问题
dart fix --apply
```

### 测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/cpu_info_test.dart

# 生成覆盖率报告
flutter test --coverage
```

---

## 提交规范

遵循 `.github/COMMIT_CONVENTION.md` 中定义的规范。

### 提交消息格式

```
<类型>(<范围>): <简短描述>

[可选的详细描述]

[可选的 Footer]
```

### 类型

- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具相关

### 示例

```
feat(models): 添加温度监控模型

- 添加 TemperatureInfo 类
- 实现 JSON 序列化
- 添加单元测试

Closes #123
```

```
fix(battery): 修复电池状态映射错误

修复 BatteryState 枚举映射不正确的问题。

Fixes #456
```

```
docs(api): 更新 API 文档

更新 getCpuInfo 方法的文档说明。
```

---

## 代码审查清单

在提交代码前，请检查：

- [ ] 代码遵循命名规范
- [ ] 使用了正确的缩进和格式
- [ ] 公共 API 有完整的文档注释
- [ ] 处理了所有可能的异常
- [ ] 使用了类型安全的代码
- [ ] 添加了必要的测试
- [ ] 运行 `flutter analyze` 无错误
- [ ] 运行 `flutter test` 所有测试通过
- [ ] 提交消息符合规范

---

**文档版本**: 1.0  
**创建日期**: 2026-03-09  
**项目**: system_monitor_kit
