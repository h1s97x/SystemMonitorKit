#ifndef FLUTTER_PLUGIN_SYSTEM_MONITOR_KIT_PLUGIN_H_
#define FLUTTER_PLUGIN_SYSTEM_MONITOR_KIT_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _SystemMonitorKitPlugin SystemMonitorKitPlugin;
typedef struct {
  GObjectClass parent_class;
} SystemMonitorKitPluginClass;

FLUTTER_PLUGIN_EXPORT GType system_monitor_kit_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void system_monitor_kit_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_SYSTEM_MONITOR_KIT_PLUGIN_H_
