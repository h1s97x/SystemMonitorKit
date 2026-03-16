# 贡献指南

感谢您对本项目的关注！本指南将帮助您扩展插件功能。

## 架构概览

```
system_monitor_kit/
├── lib/
│   ├── system_monitor_kit.dart          # 主导出文件
│   └── src/
│       ├── system_monitor.dart          # 主 API 类
│       ├── models/                      # 数据模型
│       │   ├── system_info.dart
│       │   ├── cpu_info.dart
│       │   ├── memory_info.dart
│       │   ├── disk_info.dart
│       │   ├── battery_info.dart
│       │   └── network_traffic.dart
│       └── enums/                       # 枚举
│           └── enums.dart
│
├── windows/                             # Windows 平台代码（C++）
│   ├── hardware_plugin.h
│   ├── hardware_plugin.cpp
│   └── CMakeLists.txt
│
├── android/                             # Android 平台代码（Kotlin）
│   └── src/main/kotlin/
│       └── SystemMonitorKitPlugin.kt
│
└── example/                             # 示例应用
    └── lib/main.dart
```

## 添加新的硬件信息

### 步骤 1：定义数据模型

在 `lib/src/models/` 创建新模型：

```dart
// lib/src/models/new_hardware_info.dart
class NewHardwareInfo {
  final String? property1;
  final int? property2;

  NewHardwareInfo({
    this.property1,
    this.property2,
  });

  factory NewHardwareInfo.fromJson(Map<String, dynamic> json) {
    return NewHardwareInfo(
      property1: json['property1'] as String?,
      property2: json['property2'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property1': property1,
      'property2': property2,
    };
  }
}
```

### 步骤 2：添加到 SystemInfo

更新 `lib/src/models/system_info.dart`。

### 步骤 3：添加 API 方法

在 `lib/src/system_monitor.dart` 中添加新方法。

### 步骤 4：实现 Windows 平台代码

在 `windows/hardware_plugin.cpp` 中实现。

### 步骤 5：实现 Android 平台代码

在 `android/src/main/kotlin/.../SystemMonitorKitPlugin.kt` 中实现。

### 步骤 6：添加测试

创建相应的测试文件。

### 步骤 7：更新文档

更新 README.md、API.md 等文档。

## 代码风格指南

### Dart 代码

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 指南
- 使用 `dart format` 格式化代码
- 运行 `flutter analyze` 检查问题
- 为公共 API 添加文档注释

### C++ 代码（Windows）

- 遵循 Google C++ 风格指南
- 使用有意义的变量名
- 为复杂逻辑添加注释
- 适当处理错误

### Kotlin 代码（Android）

- 遵循 Kotlin 编码规范
- 使用空安全
- 为公共方法添加 KDoc 注释

## 测试

### 单元测试

```bash
flutter test
```

### 集成测试

```bash
cd example
flutter test integration_test/
```

## Pull Request 流程

1. Fork 仓库
2. 创建功能分支：`git checkout -b feature/new-hardware-info`
3. 进行修改
4. 为新功能添加测试
5. 确保所有测试通过：`flutter test`
6. 确保代码分析通过：`flutter analyze`
7. 格式化代码：`dart format .`
8. 提交并附上描述性消息：`git commit -m "feat: 添加新硬件信息"`
9. 推送到您的 fork：`git push origin feature/new-hardware-info`
10. 创建 Pull Request

### 提交消息格式

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<类型>(<范围>): <主题>

<正文>

<页脚>
```

类型：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档变更
- `style`: 代码格式变更
- `refactor`: 代码重构
- `test`: 添加或更新测试
- `chore`: 维护任务

示例：
```
feat(windows): 添加 GPU 温度监控
fix(android): 修正 Android 12+ 上的内存计算
docs: 更新新方法的 API 参考
```

## 获取帮助

- 查看现有 [issues](https://github.com/h1s97x/SystemMonitorKit/issues)
- 阅读 [文档](https://pub.dev/documentation/system_monitor_kit/latest/)
- 在 [discussions](https://github.com/h1s97x/SystemMonitorKit/discussions) 提问

## 行为准则

- 尊重和包容
- 提供建设性反馈
- 关注对社区最有利的事情
- 对其他社区成员表现出同理心

## 许可证

通过贡献，您同意您的贡献将在 MIT 许可证下授权。

## 致谢

贡献者将在以下位置获得认可：
- `AUTHORS` 文件
- 发布说明
- 项目 README

感谢您为 system_monitor_kit 做出贡献！
