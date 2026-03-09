# System Monitor Kit Benchmark

性能基准测试工具，用于评估 system_monitor_kit 的性能表现。

## 运行方式

```bash
# 运行完整的基准测试
dart run benchmark/system_monitor_benchmark.dart

# 或者使用 Flutter
flutter run benchmark/system_monitor_benchmark.dart
```

## 测试项目

### 1. 系统信息获取基准测试
测试获取完整系统信息（CPU、内存、磁盘、电池、网络）的性能。

### 2. 单个信息获取基准测试
分别测试获取各个硬件信息的性能：
- CPU 信息
- 内存信息
- 磁盘信息
- 电池信息
- 网络流量信息

### 3. 重复调用基准测试
测试重复调用同一接口的性能，用于评估缓存效果。

### 4. 并发调用基准测试
测试多个并发请求的处理性能。

### 5. 流式监控基准测试
测试持续监控流的性能表现，包括事件频率和平均间隔。

## 性能指标

- **ms/op**: 每次操作的平均耗时（毫秒）
- **iterations**: 测试迭代次数
- **concurrent**: 并发调用数量
- **events**: 流式监控产生的事件数量

## 注意事项

1. 基准测试需要在真实设备或模拟器上运行，某些功能在纯 Dart 环境中可能无法正常工作
2. 测试结果会受到设备性能、系统负载等因素影响
3. 建议在相同环境下多次运行以获得稳定的结果
4. 某些平台特定功能可能在不同平台上表现不同

## 示例输出

```
=== system_monitor_kit Performance Benchmark ===

--- System Info Retrieval Benchmark ---
  Get system info: 45.23 ms/op (100 iterations)

--- Individual Info Retrieval Benchmark ---
  Get CPU info: 12.34 ms/op
  Get memory info: 8.56 ms/op
  Get disk info: 15.67 ms/op
  Get battery info: 10.23 ms/op
  Get network traffic: 5.12 ms/op

--- Repeated Calls Benchmark ---
  Repeated CPU info calls: 11.234 ms/op (1000 iterations)

--- Concurrent Calls Benchmark ---
  Concurrent system info calls: 42.50 ms/call (10 concurrent)
  Total time: 425 ms

--- Stream Performance Benchmark ---
  Stream monitoring: 50 events in 5000 ms
  Average interval: 100.00 ms/event

=== Benchmark Complete ===
```
