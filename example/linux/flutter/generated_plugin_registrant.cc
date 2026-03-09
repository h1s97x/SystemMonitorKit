//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <system_monitor_kit/system_monitor_kit_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) system_monitor_kit_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SystemMonitorKitPlugin");
  system_monitor_kit_plugin_register_with_registrar(system_monitor_kit_registrar);
}
