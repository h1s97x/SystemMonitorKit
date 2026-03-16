# Changelog | 更新日志

## Table of Contents | 目录

- [English](#english)
- [中文](#中文)

---

## English

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [1.0.1] - 2026-03-16

#### Added

- Comprehensive dartdoc comments for all public APIs
- Detailed documentation for SystemMonitor class and all methods
- Usage examples in dartdoc comments
- Documentation for all model classes (BatteryInfo, CpuInfo, MemoryInfo, DiskInfo, NetworkTraffic, SystemInfo)
- Detailed getter documentation with unit information

#### Changed

- Enhanced code documentation quality
- Improved API documentation clarity

### [1.0.0] - 2026-03-08

#### Added

- Initial release of system_monitor_kit
- CPU monitoring (usage rate, core count, architecture)
- Memory monitoring (total, used, available, usage rate)
- Disk monitoring (total space, used space, available space)
- Battery monitoring (level, status, charging state, low power mode)
- Network traffic monitoring (received/sent bytes, rate)
- Configurable interval real-time monitoring stream
- Battery status change stream
- Comprehensive system information aggregation
- Cross-platform support (Android, iOS, Windows, Linux, macOS)

#### Core Features

- **SystemMonitor**: Main monitoring class with singleton pattern
- **BatteryInfo**: Battery information with low battery detection
- **CpuInfo**: CPU usage rate and hardware information
- **MemoryInfo**: Memory statistics with GB/MB unit conversion
- **DiskInfo**: Disk space information with GB/MB unit conversion
- **NetworkTraffic**: Network traffic with rate calculation
- **SystemInfo**: Aggregated system information
- **Monitoring Streams**: Real-time data streams for continuous monitoring

#### Documentation

- Complete README documentation and usage examples
- Quick start guide
- API reference documentation
- Architecture design documentation
- Code style guide
- Example application with beautiful UI
- Chinese language support

#### Dependencies

- battery_plus: ^6.0.0 - Battery information
- device_info_plus: ^10.0.0 - Device information
- disk_space_plus: ^0.2.1 - Disk space information

#### Platform Support

- ✅ Android (API 21+)
- ✅ Windows (Windows 10+)
- 🚧 iOS (Planned)
- 🚧 Linux (Planned)
- 🚧 macOS (Planned)
- ❌ Web (Not supported)

---

## 中文

本项目的所有重要变更都将记录在此文件中。
格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
并且本项目遵循[语义化版本](https://semver.org/lang/zh-CN/)。

### [1.0.1] - 2026-03-16

#### 新增功能

- 双语 Changelog 支持（英文和中文）
- 增强的文档结构

#### 变更

- 改进了 Changelog 的组织和可读性

### [1.0.0] - 2026-03-08

#### 新增功能

- system_monitor_kit 首次发布
- CPU 监控（使用率、核心数、架构）
- 内存监控（总量、已用、可用、使用率）
- 磁盘监控（总空间、已用空间、可用空间）
- 电池监控（电量、状态、充电状态、省电模式）
- 网络流量监控（接收/发送字节数、速率）
- 可配置间隔的实时监控流
- 电池状态变化流
- 综合系统信息聚合
- 跨平台支持（Android、iOS、Windows、Linux、macOS）

#### 核心特性

- **SystemMonitor**: 主监控类，采用单例模式
- **BatteryInfo**: 电池信息，支持低电量检测
- **CpuInfo**: CPU 使用率和硬件信息
- **MemoryInfo**: 内存统计，支持 GB/MB 单位转换
- **DiskInfo**: 磁盘空间信息，支持 GB/MB 单位转换
- **NetworkTraffic**: 网络流量，支持速率计算
- **SystemInfo**: 聚合的系统信息
- **监控流**: 用于持续监控的实时数据流

#### 文档

- 完整的 README 文档和使用示例
- 快速入门指南
- API 参考文档
- 架构设计文档
- 代码风格指南
- 示例应用（精美 UI）
- 中文语言支持

#### 依赖项

- battery_plus: ^6.0.0 - 电池信息
- device_info_plus: ^10.0.0 - 设备信息
- disk_space_plus: ^0.2.1 - 磁盘空间信息

#### 平台支持

- ✅ Android (API 21+)
- ✅ Windows (Windows 10+)
- 🚧 iOS (计划中)
- 🚧 Linux (计划中)
- 🚧 macOS (计划中)
- ❌ Web (不支持)

---

## 版本说明 | Version Notes

### 版本号格式 | Version Format

本项目使用语义化版本号：`主版本号.次版本号.修订号`

This project uses semantic versioning: `MAJOR.MINOR.PATCH`

- **主版本号 | MAJOR**: 不兼容的 API 变更 | Incompatible API changes
- **次版本号 | MINOR**: 向下兼容的功能新增 | Backward compatible feature additions
- **修订号 | PATCH**: 向下兼容的问题修正 | Backward compatible bug fixes

### 变更类型 | Change Types

- **新增功能 | Added**: 新增的功能特性 | New features
- **变更 | Changed**: 现有功能的变更 | Changes in existing functionality
- **弃用 | Deprecated**: 即将移除的功能 | Soon-to-be removed features
- **移除 | Removed**: 已移除的功能 | Removed features
- **修复 | Fixed**: 问题修复 | Bug fixes
- **安全 | Security**: 安全相关的修复 | Security fixes
- **性能 | Performance**: 性能优化 | Performance improvements
- **文档 | Documentation**: 文档更新 | Documentation updates
- **依赖 | Dependencies**: 依赖项更新 | Dependency updates

---

## 未发布 | Unreleased

### 计划中 | Planned

- iOS 平台完整支持 | Full iOS platform support
- Linux 平台完整支持 | Full Linux platform support
- macOS 平台完整支持 | Full macOS platform support
- 真实的 CPU 使用率监控（原生实现）| Real CPU usage monitoring (native implementation)
- 真实的内存信息监控（原生实现）| Real memory information monitoring (native implementation)
- 真实的网络流量监控（原生实现）| Real network traffic monitoring (native implementation)
- GPU 信息监控 | GPU information monitoring
- 温度监控（CPU、GPU、电池）| Temperature monitoring (CPU, GPU, Battery)
- 进程监控 | Process monitoring
- 系统启动时间 | System boot time
- 网络连接状态 | Network connection status
- 更多便捷的数据分析方法 | More convenient data analysis methods

---

## 贡献 | Contributing

欢迎提交问题和拉取请求！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何贡献。

We welcome issues and pull requests! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute.

## 许可证 | License

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
