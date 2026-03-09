import 'package:flutter_test/flutter_test.dart';
import 'package:system_monitor_kit/system_monitor_kit.dart';

void main() {
  test('SystemMonitor instance', () {
    final monitor = SystemMonitor();
    expect(monitor, isNotNull);
  });

  test('BatteryInfo serialization', () {
    final battery = BatteryInfo(
      level: 80,
      state: BatteryState.charging,
      isCharging: true,
    );

    final json = battery.toJson();
    expect(json['level'], 80);
    expect(json['state'], 'charging');
    expect(json['isCharging'], true);

    final restored = BatteryInfo.fromJson(json);
    expect(restored.level, 80);
    expect(restored.state, BatteryState.charging);
  });

  test('CpuInfo serialization', () {
    final cpu = CpuInfo(
      usage: 45.5,
      coreCount: 8,
      architecture: 'ARM',
    );

    final json = cpu.toJson();
    expect(json['usage'], 45.5);
    expect(json['coreCount'], 8);

    final restored = CpuInfo.fromJson(json);
    expect(restored.usage, 45.5);
    expect(restored.coreCount, 8);
  });
}
