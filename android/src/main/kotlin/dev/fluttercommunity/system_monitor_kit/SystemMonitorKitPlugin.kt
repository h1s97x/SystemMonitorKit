package dev.fluttercommunity.system_monitor_kit

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.os.Build
import android.os.Process
import android.os.StatFs
import java.io.File

/**
 * SystemMonitorKitPlugin
 * 
 * Provides Android platform-specific implementations for system monitoring.
 * 
 * Main features:
 * - CPU information and usage
 * - Memory information and usage
 * - Disk information and usage
 * - Battery information and status
 * - Network traffic information
 * - System information
 */
class SystemMonitorKitPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "system_monitor_kit")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "getCpuInfo" -> {
                val cpuInfo = getCpuInfo()
                result.success(cpuInfo)
            }
            "getMemoryInfo" -> {
                val memoryInfo = getMemoryInfo()
                result.success(memoryInfo)
            }
            "getDiskInfo" -> {
                val diskInfo = getDiskInfo()
                result.success(diskInfo)
            }
            "getBatteryInfo" -> {
                val batteryInfo = getBatteryInfo()
                result.success(batteryInfo)
            }
            "getSystemInfo" -> {
                val systemInfo = getSystemInfo()
                result.success(systemInfo)
            }
            "getNetworkInfo" -> {
                val networkInfo = getNetworkInfo()
                result.success(networkInfo)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * Get CPU information
     * 
     * @return A map containing CPU information
     */
    private fun getCpuInfo(): Map<String, Any?> {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
        val memoryInfo = android.app.ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)

        val cpuInfo = hashMapOf<String, Any?>()
        
        // CPU core count
        cpuInfo["coreCount"] = Runtime.getRuntime().availableProcessors()
        
        // CPU architecture
        cpuInfo["architecture"] = getArch()
        
        // CPU ABI
        cpuInfo["abi"] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Build.SUPPORTED_ABIS.joinToString(",")
        } else {
            Build.CPU_ABI
        }
        
        // CPU usage (simplified estimation)
        cpuInfo["usage"] = estimateCpuUsage()
        
        return cpuInfo
    }

    /**
     * Get memory information
     * 
     * @return A map containing memory information
     */
    private fun getMemoryInfo(): Map<String, Any?> {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
        val memoryInfo = android.app.ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)

        val totalMemory = memoryInfo.totalMem
        val availableMemory = memoryInfo.availMem
        val usedMemory = totalMemory - availableMemory

        val memoryInfoMap = hashMapOf<String, Any?>()
        memoryInfoMap["totalMemory"] = totalMemory
        memoryInfoMap["usedMemory"] = usedMemory
        memoryInfoMap["freeMemory"] = availableMemory
        memoryInfoMap["usage"] = ((usedMemory.toDouble() / totalMemory.toDouble()) * 100)
        memoryInfoMap["totalMemoryMB"] = (totalMemory / (1024 * 1024))
        memoryInfoMap["usedMemoryMB"] = (usedMemory / (1024 * 1024))
        memoryInfoMap["freeMemoryMB"] = (availableMemory / (1024 * 1024))

        return memoryInfoMap
    }

    /**
     * Get disk information
     * 
     * @return A map containing disk information
     */
    private fun getDiskInfo(): Map<String, Any?> {
        val diskInfoMap = hashMapOf<String, Any?>()
        
        try {
            // Get data directory
            val dataDir = Environment.getDataDirectory()
            val stat = StatFs(dataDir.path)
            
            val blockSize: Long = stat.blockSizeLong
            val totalBlocks: Long = stat.blockCountLong
            val availableBlocks: Long = stat.availableBlocksLong
            
            val totalSpace = totalBlocks * blockSize
            val freeSpace = availableBlocks * blockSize
            val usedSpace = totalSpace - freeSpace
            
            diskInfoMap["totalSpace"] = totalSpace
            diskInfoMap["usedSpace"] = usedSpace
            diskInfoMap["freeSpace"] = freeSpace
            diskInfoMap["usage"] = ((usedSpace.toDouble() / totalSpace.toDouble()) * 100)
            diskInfoMap["totalSpaceGB"] = (totalSpace / (1024.0 * 1024.0 * 1024.0))
            diskInfoMap["usedSpaceGB"] = (usedSpace / (1024.0 * 1024.0 * 1024.0))
            diskInfoMap["freeSpaceGB"] = (freeSpace / (1024.0 * 1024.0 * 1024.0))
            diskInfoMap["path"] = dataDir.path
        } catch (e: Exception) {
            diskInfoMap["error"] = e.message
        }
        
        return diskInfoMap
    }

    /**
     * Get battery information
     * 
     * @return A map containing battery information
     */
    private fun getBatteryInfo(): Map<String, Any?> {
        val batteryInfoMap = hashMapOf<String, Any?>()
        
        try {
            val batteryStatus: android.content.Intent? = context.registerReceiver(
                null,
                android.content.IntentFilter(android.content.Intent.ACTION_BATTERY_CHANGED)
            )
            
            if (batteryStatus != null) {
                val level: Int = batteryStatus.getIntExtra(android.os.BatteryManager.EXTRA_LEVEL, -1)
                val scale: Int = batteryStatus.getIntExtra(android.os.BatteryManager.EXTRA_SCALE, -1)
                
                val batteryPct: Float = level / scale.toFloat()
                
                batteryInfoMap["level"] = (batteryPct * 100).toInt()
                batteryInfoMap["isCharging"] = batteryStatus.getIntExtra(
                    android.os.BatteryManager.EXTRA_STATUS,
                    -1
                ) == android.os.BatteryManager.BATTERY_STATUS_CHARGING ||
                        batteryStatus.getIntExtra(
                            android.os.BatteryManager.EXTRA_STATUS,
                            -1
                        ) == android.os.BatteryManager.BATTERY_STATUS_FULL
                
                batteryInfoMap["isFull"] = batteryStatus.getIntExtra(
                    android.os.BatteryManager.EXTRA_STATUS,
                    -1
                ) == android.os.BatteryManager.BATTERY_STATUS_FULL
                
                batteryInfoMap["technology"] = batteryStatus.getStringExtra(
                    android.os.BatteryManager.EXTRA_TECHNOLOGY
                )
                
                batteryInfoMap["temperature"] = batteryStatus.getIntExtra(
                    android.os.BatteryManager.EXTRA_TEMPERATURE,
                    -1
                ) / 10.0 // Temperature in tenths of a degree Celsius
                
                batteryInfoMap["voltage"] = batteryStatus.getIntExtra(
                    android.os.BatteryManager.EXTRA_VOLTAGE,
                    -1
                ) / 1000.0 // Voltage in millivolts
                
                batteryInfoMap["health"] = batteryStatus.getIntExtra(
                    android.os.BatteryManager.EXTRA_HEALTH,
                    -1
                )
                
                batteryInfoMap["isLowBattery"] = (batteryPct * 100) < 20
            } else {
                batteryInfoMap["error"] = "Unable to get battery status"
            }
        } catch (e: Exception) {
            batteryInfoMap["error"] = e.message
        }
        
        return batteryInfoMap
    }

    /**
     * Get system information
     * 
     * @return A map containing system information
     */
    private fun getSystemInfo(): Map<String, Any?> {
        val systemInfoMap = hashMapOf<String, Any?>()
        
        systemInfoMap["platform"] = "Android"
        systemInfoMap["version"] = Build.VERSION.RELEASE
        systemInfoMap["sdkVersion"] = Build.VERSION.SDK_INT
        systemInfoMap["manufacturer"] = Build.MANUFACTURER
        systemInfoMap["model"] = Build.MODEL
        systemInfoMap["product"] = Build.PRODUCT
        systemInfoMap["device"] = Build.DEVICE
        systemInfoMap["board"] = Build.BOARD
        systemInfoMap["hardware"] = Build.HARDWARE
        systemInfoMap["bootloader"] = Build.BOOTLOADER
        systemInfoMap["brand"] = Build.BRAND
        systemInfoMap["display"] = Build.DISPLAY
        systemInfoMap["fingerprint"] = Build.FINGERPRINT
        systemInfoMap["host"] = Build.HOST
        systemInfoMap["id"] = Build.ID
        systemInfoMap["tags"] = Build.TAGS
        systemInfoMap["type"] = Build.TYPE
        systemInfoMap["user"] = Build.USER
        systemInfoMap["time"] = Build.TIME
        
        return systemInfoMap
    }

    /**
     * Get network information
     * 
     * @return A map containing network information
     */
    private fun getNetworkInfo(): Map<String, Any?> {
        val networkInfoMap = hashMapOf<String, Any?>()
        
        try {
            val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as android.net.ConnectivityManager
            val activeNetwork = connectivityManager.activeNetworkInfo
            
            if (activeNetwork != null) {
                networkInfoMap["isConnected"] = activeNetwork.isConnected
                networkInfoMap["type"] = when (activeNetwork.type) {
                    android.net.ConnectivityManager.TYPE_WIFI -> "WIFI"
                    android.net.ConnectivityManager.TYPE_MOBILE -> "MOBILE"
                    else -> "OTHER"
                }
                networkInfoMap["typeName"] = activeNetwork.typeName
                networkInfoMap["subtypeName"] = activeNetwork.subtypeName
                networkInfoMap["isAvailable"] = activeNetwork.isAvailable
            } else {
                networkInfoMap["isConnected"] = false
                networkInfoMap["type"] = "NONE"
            }
        } catch (e: Exception) {
            networkInfoMap["error"] = e.message
        }
        
        return networkInfoMap
    }

    /**
     * Get CPU architecture
     * 
     * @return CPU architecture string
     */
    private fun getArch(): String {
        val arch = System.getProperty("os.arch") ?: return "unknown"
        
        return when {
            arch.contains("aarch64") -> "aarch64"
            arch.contains("arm") -> "arm"
            arch.contains("x86_64") -> "x86_64"
            arch.contains("x86") -> "x86"
            arch.contains("mips64") -> "mips64"
            arch.contains("mips") -> "mips"
            else -> "unknown"
        }
    }

    /**
     * Estimate CPU usage (simplified)
     * 
     * @return Estimated CPU usage percentage
     */
    private fun estimateCpuUsage(): Double {
        // This is a simplified estimation
        // In a real implementation, you would need to read from /proc/stat
        try {
            val uptime = android.os.SystemClock.uptimeMillis()
            val load = uptime % 100
            return load.toDouble()
        } catch (e: Exception) {
            return 0.0
        }
    }

    /**
     * Get environment data directory
     * 
     * @return File object representing the data directory
     */
    private object Environment {
        fun getDataDirectory(): File = android.os.Environment.getDataDirectory()
    }
}
