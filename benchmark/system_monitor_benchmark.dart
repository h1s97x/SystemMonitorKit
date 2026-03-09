// ignore_for_file: avoid_print

/// Benchmark tests for system_monitor_kit.
///
/// Run with: dart run benchmark/system_monitor_benchmark.dart
library;

import 'dart:async';
import 'package:system_monitor_kit/system_monitor_kit.dart';

void main() async {
  print('=== system_monitor_kit Performance Benchmark ===\n');

  final monitor = SystemMonitor();

  // Run benchmarks
  await benchmarkSystemInfoRetrieval(monitor);
  await benchmarkIndividualInfoRetrieval(monitor);
  await benchmarkRepeatedCalls(monitor);
  await benchmarkConcurrentCalls(monitor);
  await benchmarkStreamPerformance(monitor);

  print('\n=== Benchmark Complete ===');
}

/// Benchmark: 获取完整系统信息的性能
Future<void> benchmarkSystemInfoRetrieval(SystemMonitor monitor) async {
  print('--- System Info Retrieval Benchmark ---');

  final stopwatch = Stopwatch()..start();
  const iterations = 100;

  for (int i = 0; i < iterations; i++) {
    try {
      await monitor.getSystemInfo();
    } catch (e) {
      // 忽略错误（在非平台环境中可能失败）
    }
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMilliseconds / iterations;
  print(
    '  Get system info: ${avgTime.toStringAsFixed(2)} ms/op ($iterations iterations)',
  );
  print('');
}

/// Benchmark: 获取单个硬件信息的性能
Future<void> benchmarkIndividualInfoRetrieval(SystemMonitor monitor) async {
  print('--- Individual Info Retrieval Benchmark ---');

  const iterations = 100;

  // CPU Info
  var stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    try {
      await monitor.getCpuInfo();
    } catch (e) {
      // 忽略错误
    }
  }
  stopwatch.stop();
  print(
    '  Get CPU info: ${(stopwatch.elapsedMilliseconds / iterations).toStringAsFixed(2)} ms/op',
  );

  // Memory Info
  stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    try {
      await monitor.getMemoryInfo();
    } catch (e) {
      // 忽略错误
    }
  }
  stopwatch.stop();
  print(
    '  Get memory info: ${(stopwatch.elapsedMilliseconds / iterations).toStringAsFixed(2)} ms/op',
  );

  // Disk Info
  stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    try {
      await monitor.getDiskInfo();
    } catch (e) {
      // 忽略错误
    }
  }
  stopwatch.stop();
  print(
    '  Get disk info: ${(stopwatch.elapsedMilliseconds / iterations).toStringAsFixed(2)} ms/op',
  );

  // Battery Info
  stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    try {
      await monitor.getBatteryInfo();
    } catch (e) {
      // 忽略错误
    }
  }
  stopwatch.stop();
  print(
    '  Get battery info: ${(stopwatch.elapsedMilliseconds / iterations).toStringAsFixed(2)} ms/op',
  );

  // Network Traffic
  stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    try {
      await monitor.getNetworkTraffic();
    } catch (e) {
      // 忽略错误
    }
  }
  stopwatch.stop();
  print(
    '  Get network traffic: ${(stopwatch.elapsedMilliseconds / iterations).toStringAsFixed(2)} ms/op',
  );

  print('');
}

/// Benchmark: 重复调用的性能（测试缓存效果）
Future<void> benchmarkRepeatedCalls(SystemMonitor monitor) async {
  print('--- Repeated Calls Benchmark ---');

  const iterations = 1000;

  final stopwatch = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    try {
      await monitor.getCpuInfo();
    } catch (e) {
      // 忽略错误
    }
  }
  stopwatch.stop();

  final avgTime = stopwatch.elapsedMilliseconds / iterations;
  print(
    '  Repeated CPU info calls: ${avgTime.toStringAsFixed(3)} ms/op ($iterations iterations)',
  );
  print('');
}

/// Benchmark: 并发调用的性能
Future<void> benchmarkConcurrentCalls(SystemMonitor monitor) async {
  print('--- Concurrent Calls Benchmark ---');

  const concurrentCalls = 10;

  final stopwatch = Stopwatch()..start();

  try {
    await Future.wait([
      for (int i = 0; i < concurrentCalls; i++) monitor.getSystemInfo(),
    ]);
  } catch (e) {
    // 忽略错误
  }

  stopwatch.stop();

  final avgTime = stopwatch.elapsedMilliseconds / concurrentCalls;
  print(
    '  Concurrent system info calls: ${avgTime.toStringAsFixed(2)} ms/call ($concurrentCalls concurrent)',
  );
  print('  Total time: ${stopwatch.elapsedMilliseconds} ms');
  print('');
}

/// Benchmark: 流式监控性能
Future<void> benchmarkStreamPerformance(SystemMonitor monitor) async {
  print('--- Stream Performance Benchmark ---');

  const duration = Duration(seconds: 5);
  const interval = Duration(milliseconds: 100);
  
  final stopwatch = Stopwatch()..start();
  int eventCount = 0;
  final completer = Completer<void>();

  final subscription = monitor
      .createMonitorStream(interval: interval)
      .listen(
        (info) {
          eventCount++;
        },
        onError: (e) {
          // 忽略错误
        },
      );

  // 运行指定时间后停止
  Future.delayed(duration, () {
    subscription.cancel();
    stopwatch.stop();
    completer.complete();
  });

  await completer.future;

  final avgInterval = stopwatch.elapsedMilliseconds / eventCount;
  print(
    '  Stream monitoring: $eventCount events in ${stopwatch.elapsedMilliseconds} ms',
  );
  print(
    '  Average interval: ${avgInterval.toStringAsFixed(2)} ms/event',
  );
  print('');
}
