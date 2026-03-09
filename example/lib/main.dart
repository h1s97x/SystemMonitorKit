import 'package:flutter/material.dart';
import 'package:system_monitor_kit/system_monitor_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Monitor Kit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _monitor = SystemMonitor();
  SystemInfo? _systemInfo;
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
    final info = await _monitor.getSystemInfo();
    setState(() => _systemInfo = info);
  }

  void _toggleMonitoring() {
    setState(() => _isMonitoring = !_isMonitoring);
    
    if (_isMonitoring) {
      _monitor.createMonitorStream(
        interval: const Duration(seconds: 2),
      ).listen((info) {
        if (mounted && _isMonitoring) {
          setState(() => _systemInfo = info);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Monitor Kit Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isMonitoring ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleMonitoring,
            tooltip: _isMonitoring ? '暂停监控' : '开始监控',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSystemInfo,
            tooltip: '刷新',
          ),
        ],
      ),
      body: _systemInfo == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSystemInfo,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_isMonitoring)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.sensors, color: Colors.green),
                          SizedBox(width: 8),
                          Text('实时监控中...', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  _buildCpuCard(),
                  _buildMemoryCard(),
                  _buildDiskCard(),
                  _buildBatteryCard(),
                  _buildNetworkCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildCpuCard() {
    final cpu = _systemInfo?.cpu;
    if (cpu == null) return const SizedBox();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.memory, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('CPU', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressBar('使用率', cpu.usage, Colors.blue),
            const SizedBox(height: 8),
            _buildInfoRow('核心数', '${cpu.coreCount}'),
            if (cpu.architecture != null)
              _buildInfoRow('架构', cpu.architecture!),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryCard() {
    final memory = _systemInfo?.memory;
    if (memory == null) return const SizedBox();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('内存', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressBar('使用率', memory.usage, Colors.orange),
            const SizedBox(height: 8),
            _buildInfoRow('总内存', '${memory.totalMemoryGB.toStringAsFixed(2)} GB'),
            _buildInfoRow('已用', '${memory.usedMemoryGB.toStringAsFixed(2)} GB'),
            _buildInfoRow('可用', '${memory.freeMemoryGB.toStringAsFixed(2)} GB'),
          ],
        ),
      ),
    );
  }

  Widget _buildDiskCard() {
    final disk = _systemInfo?.disk;
    if (disk == null) return const SizedBox();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sd_storage, color: Colors.purple),
                const SizedBox(width: 8),
                const Text('磁盘', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressBar('使用率', disk.usage, Colors.purple),
            const SizedBox(height: 8),
            _buildInfoRow('总空间', '${disk.totalSpaceGB.toStringAsFixed(2)} GB'),
            _buildInfoRow('已用', '${disk.usedSpaceGB.toStringAsFixed(2)} GB'),
            _buildInfoRow('可用', '${disk.freeSpaceGB.toStringAsFixed(2)} GB'),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryCard() {
    final battery = _systemInfo?.battery;
    if (battery == null) return const SizedBox();

    Color color = Colors.green;
    if (battery.isCriticalBattery) {
      color = Colors.red;
    } else if (battery.isLowBattery) {
      color = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  battery.isCharging ? Icons.battery_charging_full : Icons.battery_std,
                  color: color,
                ),
                const SizedBox(width: 8),
                const Text('电池', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressBar('电量', battery.level.toDouble(), color),
            const SizedBox(height: 8),
            _buildInfoRow('状态', battery.state.name),
            _buildInfoRow('充电', battery.isCharging ? '是' : '否'),
            if (battery.isInBatterySaveMode)
              _buildInfoRow('省电模式', '开启'),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkCard() {
    final network = _systemInfo?.network;
    if (network == null) return const SizedBox();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.network_check, color: Colors.teal),
                const SizedBox(width: 8),
                const Text('网络', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('下载速率', '${network.receiveRateKBps.toStringAsFixed(1)} KB/s'),
            _buildInfoRow('上传速率', '${network.sendRateKBps.toStringAsFixed(1)} KB/s'),
            _buildInfoRow('已接收', '${network.receivedMB.toStringAsFixed(2)} MB'),
            _buildInfoRow('已发送', '${network.sentMB.toStringAsFixed(2)} MB'),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${value.toStringAsFixed(1)}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
