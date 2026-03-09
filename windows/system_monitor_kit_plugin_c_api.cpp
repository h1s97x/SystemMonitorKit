#include "include/system_monitor_kit/system_monitor_kit_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "system_monitor_kit_plugin.h"

void SystemMonitorKitPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  system_monitor_kit::SystemMonitorKitPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
