// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:system_monitor_kit/system_monitor_kit.dart';

/// 集成测试版本的性能基准测试
///
/// 运行方式：
/// flutter test integration_test/benchmark_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('System Monitor Kit Benchmark', () {
    late SystemMonitor monitor;

    setUpAll(() {
      monitor = SystemMonitor();
      print('\n=== system_monitor_kit Performance Benchmark ===\n');
    });

    test('System Info Retrieval Benchmark', () async {
      print('--- System Info Retrieval Benchmark ---');

      final stopwatch = Stopwatch()..start();
      const iterations = 100;

      for (int i = 0; i < iterations; i++) {
        try {
          await monitor.getSystemInfo();
        } catch (e) {
          // 忽略错误（在某些平台上可能失败）
        }
      }

      stopwatch.stop();
      final avgTime = stopwatch.elapsedMilliseconds / iterations;
      print(
        '  Get system info: ${avgTime.toStringAsFixed(2)} ms/op ($iterations iterations)',
      );
      print('');
    });

    test('Individual Info Retrieval Benchmark', () async {
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
    });

    test('Repeated Calls Benchmark', () async {
      print('--- Repeated Calls Benchmark ---');

      const iterations = 100; // 减少迭代次数以避免超时

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
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('Concurrent Calls Benchmark', () async {
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
    });

    test('Stream Performance Benchmark', () async {
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

      final avgInterval = eventCount > 0
          ? stopwatch.elapsedMilliseconds / eventCount
          : 0.0;
      print(
        '  Stream monitoring: $eventCount events in ${stopwatch.elapsedMilliseconds} ms',
      );
      print(
        '  Average interval: ${avgInterval.toStringAsFixed(2)} ms/event',
      );
      print('');
    });

    tearDownAll(() {
      print('=== Benchmark Complete ===\n');
    });
  });
}
