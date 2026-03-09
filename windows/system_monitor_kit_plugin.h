#ifndef FLUTTER_PLUGIN_SYSTEM_MONITOR_KIT_PLUGIN_H_
#define FLUTTER_PLUGIN_SYSTEM_MONITOR_KIT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace system_monitor_kit {

class SystemMonitorKitPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SystemMonitorKitPlugin();

  virtual ~SystemMonitorKitPlugin();

  // Disallow copy and assign.
  SystemMonitorKitPlugin(const SystemMonitorKitPlugin&) = delete;
  SystemMonitorKitPlugin& operator=(const SystemMonitorKitPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace system_monitor_kit

#endif  // FLUTTER_PLUGIN_SYSTEM_MONITOR_KIT_PLUGIN_H_
