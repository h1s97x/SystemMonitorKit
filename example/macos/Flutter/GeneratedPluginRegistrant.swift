//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import battery_plus
import device_info_plus
import disks_desktop
import system_monitor_kit

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  BatteryPlusMacosPlugin.register(with: registry.registrar(forPlugin: "BatteryPlusMacosPlugin"))
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  DisksDesktopPlugin.register(with: registry.registrar(forPlugin: "DisksDesktopPlugin"))
  SystemMonitorKitPlugin.register(with: registry.registrar(forPlugin: "SystemMonitorKitPlugin"))
}
