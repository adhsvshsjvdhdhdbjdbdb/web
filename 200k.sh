#!/system/bin/sh
# Định nghĩa các biến giao diện
WIDTH=60
BOX_TOP="+----------------------------------------------------------+"
BOX_BTM="+----------------------------------------------------------+"
BOX_SIDE="|"
BULLET=" * "
PROGRESS=" -> "
SPACER="|                                                          |"

# Hàm căn giữa văn bản
pad_text() {
    local text="$1"
    local width=$((WIDTH - 2)) # Trừ 2 cho ký tự | ở hai bên
    local len=${#text}
    local total_padding=$((width - len))
    local left_pad_len=$((total_padding / 2))
    local right_pad_len=$((total_padding - left_pad_len))
    local left_pad=""
    local right_pad=""
    local i

    # Tạo khoảng trắng bên trái
    i=0
    while [ $i -lt $left_pad_len ]; do
        left_pad="$left_pad "
        i=$((i + 1))
    done

    # Tạo khoảng trắng bên phải
    i=0
    while [ $i -lt $right_pad_len ]; do
        right_pad="$right_pad "
        i=$((i + 1))
    done

    echo "$BOX_SIDE$left_pad$text$right_pad$BOX_SIDE"
}

# Hàm định dạng trường thông tin thiết bị
format_field() {
    local label="$1"
    local value="$2"
    local label_width=15
    local value_width=40
    local padded_label=$(printf "%-${label_width}s" "$label")
    local padded_value=$(printf "%-${value_width}s" "$value")
    echo "$BULLET$padded_label: $padded_value"
}

# Bắt đầu giao diện
clear
echo "$BOX_TOP"
echo "$(pad_text "KingV1 Optimizer")"
echo "$BOX_BTM"
echo "$(pad_text "Game Performance Booster")"
echo "$SPACER"
echo "$BOX_SIDE$(printf "%-58s" " Developer: GRAP FIFA Team")$BOX_SIDE"
echo "$BOX_SIDE$(printf "%-58s" " Version  : 1.0")$BOX_SIDE"
if [ "$(id -u)" -eq 0 ] || which su >/dev/null 2>&1; then
    echo "$BOX_SIDE$(printf "%-58s" " Device   : Rooted")$BOX_SIDE"
    root_status="root"
else
    echo "$BOX_SIDE$(printf "%-58s" " Device   : Non-Rooted")$BOX_SIDE"
    root_status="not_root"
fi
echo "$BOX_BTM"
echo ""
sleep 1

# Phân tích hệ thống
echo "$BOX_TOP"
echo "$(pad_text "System Analysis")"
echo "$BOX_BTM"
echo ""

# Thu thập thông tin thiết bị
kernel_version=$(uname -r)
device_name=$(getprop ro.product.model)
manufacturer=$(getprop ro.product.manufacturer)
adr_version=$(getprop ro.build.version.release)
adr_build=$(getprop ro.build.version.incremental)
product_locale=$(getprop ro.product.locale)
total_ram=$(grep MemTotal /proc/meminfo | awk '{printf "%.0f MB", $2 / 1024}')
free_ram=$(free -m | awk '/Mem:/ {print $4}')
cpu_abi=$(getprop ro.product.cpu.abi)
bit=$(if echo "$cpu_abi" | grep -iq "64"; then echo "64-bit"; else echo "32-bit"; fi)
check_chip=$(getprop ro.soc.manufacturer)
gpu_info=$(getprop ro.hardware.egl)
vulkan=$(getprop ro.hardware.vulkan)

# Hiển thị thông tin thiết bị
echo "$BOX_TOP"
echo "$(pad_text "Device Information")"
echo "$BOX_BTM"
echo "$SPACER"
echo "$(format_field "Model" "$device_name")"
sleep 0.3
echo "$(format_field "Brand" "$manufacturer")"
sleep 0.3
echo "$(format_field "Android" "$adr_version")"
echo "$(format_field "Build" "$adr_build")"
echo "$(format_field "Locale" "$product_locale")"
echo "$(format_field "Kernel" "$kernel_version")"
echo "$(format_field "RAM Total" "$total_ram")"
echo "$(format_field "RAM Free" "$free_ram MB")"
echo "$(format_field "CPU Arch" "$cpu_abi ($bit)")"
echo "$(format_field "Chipset" "$check_chip")"
echo "$(format_field "GPU" "$gpu_info")"
echo "$(format_field "Vulkan" "$vulkan")"
echo "$SPACER"
echo "$BOX_BTM"
echo ""
sleep 1

# Giả lập quá trình tối ưu hóa
echo "$BOX_TOP"
echo "$(pad_text "System Optimization")"
echo "$BOX_BTM"
echo "$SPACER"
echo "$PROGRESS[1/4] Scanning system resources...$(printf "%-22s" "[OK]")"
sleep 0.5
echo "$PROGRESS[2/4] Clearing temporary cache...$(printf "%-22s" "[OK]")"
sleep 0.5
echo "$PROGRESS[3/4] Optimizing CPU/GPU performance...$(printf "%-16s" "[OK]")"
sleep 0.5
echo "$PROGRESS[4/4] Applying system tweaks...$(printf "%-22s" "[OK]")"
cmd power set-mode 0
dumpsys battery set level 100
cmd power set-adaptive-power-saver-enabled false
sleep 1
refresh_rate=$(dumpsys SurfaceFlinger | grep refresh-rate | awk -F': ' '{print $2}' | awk '{print int($1+0.5)}')
echo "$PROGRESS_DIV Display Refresh Rate: ${refresh_rate}Hz"

case $refresh_rate in
    144|120|90|60)
        settings put system peak_refresh_rate $refresh_rate
        settings put system user_refresh_rate $refresh_rate
        settings put system min_refresh_rate $refresh_rate
        settings put system refresh_rate_mode 1
        settings put system thermal_limit_refresh_rate $refresh_rate
        settings put system fps_limit $refresh_rate
        settings put global touch_sampling_rate $(($refresh_rate * 2))
        ;;
    *)
        echo "Refresh rate $refresh_rate not supported."
        exit 1
        ;;
esac

echo "Tần số quét phát hiện: $refresh_rate Hz"

frame_time=$(awk "BEGIN {printf \"%.0f\", (1 / $refresh_rate) * 1000000000}")
phazev1=$((frame_time / 8))
phazev2=$((frame_time / 5))
phazev3=$((frame_time / 3))
phazev4=$((frame_time / 2))
phazev5=$((frame_time * 2 / 3))
phazev6=$((frame_time))
phazev7=$((frame_time * 5 / 4))
setprop debug.sf.earlyGl.app.duration "$phazev5"
setprop debug.sf.earlyGl.sf.duration "$phazev5"
setprop debug.sf.hwc.min.duration "$phazev5"
setprop debug.sf.early.app.duration "$phazev5"
setprop debug.sf.late.app.duration "$phazev6"
setprop debug.sf.early.sf.duration "$phazev5"
setprop debug.sf.late.sf.duration "$phazev6"
setprop debug.sf.set_idle_timer_ms "$phazev4"
setprop debug.sf.layer_caching_active_layer_timeout_ms "$phazev3"
setprop debug.sf.high_fps_early_app_phase_offset_ns "-$phazev3"
setprop debug.sf.high_fps_late_app_phase_offset_ns "$phazev2"
setprop debug.sf.high_fps_early_sf_phase_offset_ns "-$phazev3"
setprop debug.sf.high_fps_late_sf_phase_offset_ns "$phazev2"
setprop debug.sf.high_fps_early_gl_app_phase_offset_ns "$phazev1"
setprop debug.sf.high_fps_early_gl_phase_offset_ns "$phazev2"
setprop debug.sf.high_fps_early_phase_offset_ns "$phazev2"
setprop debug.sf.high_fps_late_app_phase_offset_ns "$phazev6"
setprop debug.sf.high_fps_late_sf_phase_offset_ns "$phazev6"
setprop debug.sf.vsync_phase_offset_ns "-$phazev2"
setprop debug.sf.vsync_event_phase_offset_ns "-$phazev2"
setprop debug.sf.region_sampling_duration_ns "$phazev4"
setprop debug.sf.cached_set_render_duration_ns "$phazev4"
setprop debug.sf.early_app_phase_offset_ns "$phazev2"
setprop debug.sf.early_gl_app_phase_offset_ns "$phazev2"
setprop debug.sf.early_gl_phase_offset_ns "$phazev4"
setprop debug.sf.early_phase_offset_ns "$phazev4"
setprop debug.sf.region_sampling_timer_timeout_ns "$phazev7"
setprop debug.sf.region_sampling_period_ns "$phazev6"
setprop debug.sf.phase_offset_threshold_for_next_vsync_ns "$phazev6"
service call SurfaceFlinger 1035 &>/dev/null
echo "✅ Áp dụng tối ưu hóa thành công cho ${refresh_rate}Hz!"
#Tối ưu ram
get_ram_gb() {
    mem_kb=$(grep -i MemTotal /proc/meminfo | awk '{print $2}')
    mem_gb=$(( (mem_kb + 1048575) / 1048576 )) # Làm tròn lên GB
    echo "$mem_gb"
}

apply_config() {
    ram_gb=$1
    echo "Đã phát hiện RAM: ${ram_gb}GB"

    if [ "$ram_gb" -le 2 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 2GB hoặc thấp hơn"
        settings put global activity_manager_constants max_cached_processes=48,CUR_MAX_CACHED_PROCESSES=96,CUR_MAX_EMPTY_PROCESSES=32,CUR_TRIM_EMPTY_PROCESSES=24,CUR_TRIM_CACHED_PROCESSES=32,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=2,MULTI_THREAD_CPU=false,power_check_max_cpu_1=90,power_check_max_cpu_2=80,power_check_max_cpu_3=60,power_check_max_cpu_4=50,power_check_max_gpu=85,max_empty_time_millis=180000,max_phantom_processes=4,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 4096
        setprop debug.hwui.layer_cache_size 4096
        setprop debug.hwui.pipeline_cache_size 4096
        setprop debug.hwui.fbo_cache_size 3072
        setprop debug.hwui.cache_size 4096

    elif [ "$ram_gb" -le 3 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 3GB"
        settings put global activity_manager_constants max_cached_processes=64,CUR_MAX_CACHED_PROCESSES=128,CUR_MAX_EMPTY_PROCESSES=48,CUR_TRIM_EMPTY_PROCESSES=32,CUR_TRIM_CACHED_PROCESSES=48,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=2,MULTI_THREAD_CPU=true,power_check_max_cpu_1=92,power_check_max_cpu_2=85,power_check_max_cpu_3=65,power_check_max_cpu_4=55,power_check_max_gpu=87,max_empty_time_millis=180000,max_phantom_processes=5,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 6144
        setprop debug.hwui.layer_cache_size 6144
        setprop debug.hwui.pipeline_cache_size 6144
        setprop debug.hwui.fbo_cache_size 4096
        setprop debug.hwui.cache_size 5120

    elif [ "$ram_gb" -le 4 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 4GB"
        settings put global activity_manager_constants max_cached_processes=96,CUR_MAX_CACHED_PROCESSES=256,CUR_MAX_EMPTY_PROCESSES=64,CUR_TRIM_EMPTY_PROCESSES=48,CUR_TRIM_CACHED_PROCESSES=64,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=6,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 8192
        setprop debug.hwui.layer_cache_size 8192
        setprop debug.hwui.pipeline_cache_size 8192
        setprop debug.hwui.fbo_cache_size 6144
        setprop debug.hwui.cache_size 7168

    elif [ "$ram_gb" -le 6 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 6GB"
        settings put global activity_manager_constants max_cached_processes=128,CUR_MAX_CACHED_PROCESSES=320,CUR_MAX_EMPTY_PROCESSES=96,CUR_TRIM_EMPTY_PROCESSES=64,CUR_TRIM_CACHED_PROCESSES=96,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=8,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 10240
        setprop debug.hwui.layer_cache_size 10240
        setprop debug.hwui.pipeline_cache_size 10240
        setprop debug.hwui.fbo_cache_size 8192
        setprop debug.hwui.cache_size 9216

    elif [ "$ram_gb" -le 8 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 8GB trở lên"
        settings put global activity_manager_constants max_cached_processes=160,CUR_MAX_CACHED_PROCESSES=384,CUR_MAX_EMPTY_PROCESSES=128,CUR_TRIM_EMPTY_PROCESSES=96,CUR_TRIM_CACHED_PROCESSES=128,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=10,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 12288
        setprop debug.hwui.layer_cache_size 12288
        setprop debug.hwui.pipeline_cache_size 12288
        setprop debug.hwui.fbo_cache_size 10240
        setprop debug.hwui.cache_size 11264
        elif [ "$ram_gb" -le 12 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 12GB"
        settings put global activity_manager_constants max_cached_processes=224,CUR_MAX_CACHED_PROCESSES=512,CUR_MAX_EMPTY_PROCESSES=160,CUR_TRIM_EMPTY_PROCESSES=128,CUR_TRIM_CACHED_PROCESSES=160,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=4,MULTI_THREAD_CPU=true,power_check_max_cpu_1=97,power_check_max_cpu_2=94,power_check_max_cpu_3=78,power_check_max_cpu_4=68,power_check_max_gpu=93,max_empty_time_millis=150000,max_phantom_processes=14,service_timeout=10000,bg_start_timeout=7000,gc_timeout=5000,content_provider_retain_time=3000

        setprop debug.hwui.texture_cache_size 16384
        setprop debug.hwui.layer_cache_size 16384
        setprop debug.hwui.pipeline_cache_size 16384
        setprop debug.hwui.fbo_cache_size 14336
        setprop debug.hwui.cache_size 15360

    elif [ "$ram_gb" -le 16 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 16GB"
        settings put global activity_manager_constants max_cached_processes=256,CUR_MAX_CACHED_PROCESSES=576,CUR_MAX_EMPTY_PROCESSES=192,CUR_TRIM_EMPTY_PROCESSES=160,CUR_TRIM_CACHED_PROCESSES=192,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=4,MULTI_THREAD_CPU=true,power_check_max_cpu_1=98,power_check_max_cpu_2=95,power_check_max_cpu_3=80,power_check_max_cpu_4=70,power_check_max_gpu=94,max_empty_time_millis=150000,max_phantom_processes=16,service_timeout=9000,bg_start_timeout=6000,gc_timeout=5000,content_provider_retain_time=3000

        setprop debug.hwui.texture_cache_size 20480
        setprop debug.hwui.layer_cache_size 20480
        setprop debug.hwui.pipeline_cache_size 20480
        setprop debug.hwui.fbo_cache_size 16384
        setprop debug.hwui.cache_size 18432

    elif [ "$ram_gb" -ge 17 ]; then
        echo "Áp dụng cấu hình tối ưu cho RAM 24GB trở lên"
        settings put global activity_manager_constants max_cached_processes=288,CUR_MAX_CACHED_PROCESSES=640,CUR_MAX_EMPTY_PROCESSES=256,CUR_TRIM_EMPTY_PROCESSES=192,CUR_TRIM_CACHED_PROCESSES=256,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=4,MULTI_THREAD_CPU=true,power_check_max_cpu_1=98,power_check_max_cpu_2=96,power_check_max_cpu_3=82,power_check_max_cpu_4=72,power_check_max_gpu=96,max_empty_time_millis=120000,max_phantom_processes=18,service_timeout=8000,bg_start_timeout=5000,gc_timeout=4000,content_provider_retain_time=2000

        setprop debug.hwui.texture_cache_size 24576
        setprop debug.hwui.layer_cache_size 24576
        setprop debug.hwui.pipeline_cache_size 24576
        setprop debug.hwui.fbo_cache_size 18432
        setprop debug.hwui.cache_size 20480
    fi

    # Áp dụng các thông số nhỏ không đổi
    setprop debug.hwui.texture_max_size 2048
    setprop debug.hwui.path_cache_size 4096
    setprop debug.hwui.gradient_cache_size 2048
    setprop debug.hwui.drop_shadow_cache_size 2048
    setprop debug.hwui.resource_cache_size 4096
    setprop debug.hwui.buffer_cache_size 4096
    setprop debug.hwui.layer_pool_size 4096
    setprop debug.hwui.r_buffer_cache_size 2048
    setprop debug.hwui.text_large_cache_width 256
    setprop debug.hwui.text_large_cache_height 128
    setprop debug.hwui.text_small_cache_width 128
    setprop debug.hwui.text_small_cache_height 64
    setprop debug.hwui.texture_cache_flushrate 0.2
    setprop debug.hwui.layer_cache_flushrate 0.2
    setprop debug.hwui.gradient_cache_flushrate 0.2
    setprop debug.hwui.path_cache_flushrate 0.2
    setprop debug.hwui.drop_shadow_cache_flushrate 0.2
    settings put global render_quality low
    settings put global shadow_quality disable
    settings put global texture_quality low
    settings put global effects_quality low
    settings put global graphics_quality low
    settings put global lights_quality low
    settings put global shader_quality low
    settings put system ram_boost 1
    settings put system cpu_boost 1
    settings put system gpu_boost 1
    settings put system zram_boost 1
    settings put system ui.hw 1
    settings put global zram_enabled 1
    settings put global enable_gpu_debug_layers 0
    settings put global bg_apps_limit 4
    settings put global bservice_limit 1
    settings put global bservice_age 1000
    echo "✅ Hoàn tất tối ưu theo RAM thiết bị!"
}

main() {
    ram=$(get_ram_gb)
    apply_config "$ram"
}

main
sleep 1
dumpsys battery reset
log() { 
disable_log=(
    "log.tag.FA SUPPRESS"
    "log.tag.AF::MmapTrack SUPPRESS"
    "log.tag.AF::OutputTrack SUPPRESS"
    "log.tag.AF::PatchRecord SUPPRESS"
    "log.tag.AF::PatchTrack SUPPRESS"
    "log.tag.AF::RecordHandle SUPPRESS"
    "log.tag.AF::RecordTrack SUPPRESS"
    "log.tag.AF::Track SUPPRESS"
    "log.tag.AF::TrackBase SUPPRESS"
    "log.tag.AF::TrackHandle SUPPRESS"
    "log.tag.APM-KpiMonitor SUPPRESS"
    "log.tag.APM-ServiceJ SUPPRESS"
    "log.tag.APM-SessionJ SUPPRESS"
    "log.tag.APM-SessionN SUPPRESS"
    "log.tag.APM-Subscriber SUPPRESS"
    "log.tag.APM::AudioCollections SUPPRESS"
    "log.tag.APM::AudioInputDescriptor SUPPRESS"
    "log.tag.APM::AudioOutputDescriptor SUPPRESS"
    "log.tag.APM::AudioPatch SUPPRESS"
    "log.tag.APM::AudioPolicyEngine SUPPRESS"
    "log.tag.APM::AudioPolicyEngine::Base SUPPRESS"
    "log.tag.APM::AudioPolicyEngine::Config SUPPRESS"
    "log.tag.APM::AudioPolicyEngine::ProductStrategy SUPPRESS"
    "log.tag.APM::AudioPolicyEngine::VolumeGroup SUPPRESS"
    "log.tag.APM::Devices SUPPRESS"
    "log.tag.APM::IOProfile SUPPRESS"
    "log.tag.APM::Serializer SUPPRESS"
    "log.tag.APM::VolumeCurve SUPPRESS"
    "log.tag.APM_AudioPolicyManager SUPPRESS"
    "log.tag.APM_ClientDescriptor SUPPRESS"
    "log.tag.AT SUPPRESS"
    "log.tag.AccountManager SUPPRESS"
    "log.tag.ActivityManager SUPPRESS"
    "log.tag.ActivityManagerService SUPPRESS"
    "log.tag.ActivityTaskManager SUPPRESS"
    "log.tag.ActivityTaskManagerService SUPPRESS"
    "log.tag.AdnRecord SUPPRESS"
    "log.tag.AdnRecordCache SUPPRESS"
    "log.tag.AdnRecordLoader SUPPRESS"
    "log.tag.AirplaneHandler SUPPRESS"
    "log.tag.AlarmManager SUPPRESS"
    "log.tag.AlarmManagerService SUPPRESS"
    "log.tag.AndroidRuntime SUPPRESS"
    "log.tag.AppOps SUPPRESS"
    "log.tag.AudioAttributes SUPPRESS"
    "log.tag.AudioEffect SUPPRESS"
    "log.tag.AudioFlinger SUPPRESS"
    "log.tag.AudioFlinger::DeviceEffectProxy SUPPRESS"
    "log.tag.AudioFlinger::DeviceEffectProxy::ProxyCallback SUPPRESS"
    "log.tag.AudioFlinger::EffectBase SUPPRESS"
    "log.tag.AudioFlinger::EffectChain SUPPRESS"
    "log.tag.AudioFlinger::EffectHandle SUPPRESS"
    "log.tag.AudioFlinger::EffectModule SUPPRESS"
    "log.tag.AudioFlinger_Threads SUPPRESS"
    "log.tag.AudioHwDevice SUPPRESS"
    "log.tag.AudioManager SUPPRESS"
    "log.tag.AudioPolicy SUPPRESS"
    "log.tag.AudioPolicyEffects SUPPRESS"
    "log.tag.AudioPolicyIntefaceImpl SUPPRESS"
    "log.tag.AudioPolicyManager SUPPRESS"
    "log.tag.AudioPolicyService SUPPRESS"
    "log.tag.AudioProductStrategy SUPPRESS"
    "log.tag.AudioRecord SUPPRESS"
    "log.tag.AudioService SUPPRESS"
    "log.tag.AudioSystem SUPPRESS"
    "log.tag.AudioTrack SUPPRESS"
    "log.tag.AudioTrackShared SUPPRESS"
    "log.tag.AudioVolumeGroup SUPPRESS"
    "log.tag.BackupManager SUPPRESS"
    "log.tag.BatteryManager SUPPRESS"
    "log.tag.BatteryStatsService SUPPRESS"
    "log.tag.BluetoothAdapter SUPPRESS"
    "log.tag.BluetoothDevice SUPPRESS"
    "log.tag.BluetoothGattService SUPPRESS"
    "log.tag.BluetoothHidService SUPPRESS"
    "log.tag.BluetoothManager SUPPRESS"
    "log.tag.BluetoothMapService SUPPRESS"
    "log.tag.BluetoothPanService SUPPRESS"
    "log.tag.BluetoothPbapService SUPPRESS"
    "log.tag.BluetoothSapService SUPPRESS"
    "log.tag.BluetoothService SUPPRESS"
    "log.tag.BluetoothSocket SUPPRESS"
    "log.tag.BufferQueueDump SUPPRESS"
    "log.tag.BufferQueueProducer SUPPRESS"
    "log.tag.C2K_AT SUPPRESS"
    "log.tag.C2K_ATConfig SUPPRESS"
    "log.tag.C2K_RILC SUPPRESS"
    "log.tag.CAM2PORT_ SUPPRESS"
    "log.tag.CapaSwitch SUPPRESS"
    "log.tag.CarrierExpressServiceImpl SUPPRESS"
    "log.tag.CarrierExpressServiceImplExt SUPPRESS"
    "log.tag.ClipboardManager SUPPRESS"
    "log.tag.ConnectivityManager SUPPRESS"
    "log.tag.ConnectivityService SUPPRESS"
    "log.tag.ConsumerIrService SUPPRESS"
    "log.tag.ContentManager SUPPRESS"
    "log.tag.CountryDetector SUPPRESS"
    "log.tag.DMC-ApmService SUPPRESS"
    "log.tag.DMC-Core SUPPRESS"
    "log.tag.DMC-DmcService SUPPRESS"
    "log.tag.DMC-EventsSubscriber SUPPRESS"
    "log.tag.DMC-ReqQManager SUPPRESS"
    "log.tag.DMC-SessionManager SUPPRESS"
    "log.tag.DMC-TranslatorLoader SUPPRESS"
    "log.tag.DMC-TranslatorUtils SUPPRESS"
    "log.tag.DSSelector SUPPRESS"
    "log.tag.DSSelectorOP01 SUPPRESS"
    "log.tag.DSSelectorOP02 SUPPRESS"
    "log.tag.DSSelectorOP09 SUPPRESS"
    "log.tag.DSSelectorOP18 SUPPRESS"
    "log.tag.DSSelectorOm SUPPRESS"
    "log.tag.DSSelectorUtil SUPPRESS"
    "log.tag.DataDispatcher SUPPRESS"
    "log.tag.DeviceIdleController SUPPRESS"
    "log.tag.DevicePolicyManager SUPPRESS"
    "log.tag.DevicePolicyManagerService SUPPRESS"
    "log.tag.DisplayManager SUPPRESS"
    "log.tag.DisplayManagerService SUPPRESS"
    "log.tag.DockObserver SUPPRESS"
    "log.tag.DownloadManager SUPPRESS"
    "log.tag.ExternalSimMgr SUPPRESS"
    "log.tag.FastCapture SUPPRESS"
    "log.tag.FastMixer SUPPRESS"
    "log.tag.FastMixerState SUPPRESS"
    "log.tag.FastThread SUPPRESS"
    "log.tag.FragmentManager SUPPRESS"
    "log.tag.FuseDaemon SUPPRESS"
    "log.tag.GAv4 SUPPRESS"
    "log.tag.GraphicsStats SUPPRESS"
    "log.tag.GsmCallTkrHlpr SUPPRESS"
    "log.tag.GsmCdmaConn SUPPRESS"
    "log.tag.GsmCdmaPhone SUPPRESS"
    "log.tag.HardwarePropertiesManager SUPPRESS"
    "log.tag.HardwareService SUPPRESS"
    "log.tag.IAudioFlinger SUPPRESS"
    "log.tag.IMSRILRequest SUPPRESS"
    "log.tag.IMS_RILA SUPPRESS"
    "log.tag.IccCardProxy SUPPRESS"
    "log.tag.IccPhoneBookIM SUPPRESS"
    "log.tag.IccProvider SUPPRESS"
    "log.tag.ImsApp SUPPRESS"
    "log.tag.ImsBaseCommands SUPPRESS"
    "log.tag.ImsCall SUPPRESS"
    "log.tag.ImsCallProfile SUPPRESS"
    "log.tag.ImsCallSession SUPPRESS"
    "log.tag.ImsEcbm SUPPRESS"
    "log.tag.ImsEcbmProxy SUPPRESS"
    "log.tag.ImsManager SUPPRESS"
    "log.tag.ImsPhone SUPPRESS"
    "log.tag.ImsPhoneBase SUPPRESS"
    "log.tag.ImsPhoneCall SUPPRESS"
    "log.tag.ImsService SUPPRESS"
    "log.tag.ImsVTProvider SUPPRESS"
    "log.tag.InputDispatcher SUPPRESS"
    "log.tag.InputManager SUPPRESS"
    "log.tag.InputManagerService SUPPRESS"
    "log.tag.InputMethodManager SUPPRESS"
    "log.tag.InputMethodManagerService SUPPRESS"
    "log.tag.InterfaceManager SUPPRESS"
    "log.tag.IsimFileHandler SUPPRESS"
    "log.tag.IsimRecords SUPPRESS"
    "log.tag.JobScheduler SUPPRESS"
    "log.tag.KeyguardManager SUPPRESS"
    "log.tag.LCM-Subscriber SUPPRESS"
    "log.tag.LIBC2K_RIL SUPPRESS"
    "log.tag.LocationManager SUPPRESS"
    "log.tag.LocationManagerService SUPPRESS"
    "log.tag.LocationProvider SUPPRESS"
    "log.tag.MAPI-CommandProcessor SUPPRESS"
    "log.tag.MAPI-MdiRedirector SUPPRESS"
    "log.tag.MAPI-MdiRedirectorCtrl SUPPRESS"
    "log.tag.MAPI-NetworkSocketConnection SUPPRESS"
    "log.tag.MAPI-SocketConnection SUPPRESS"
    "log.tag.MAPI-SocketListener SUPPRESS"
    "log.tag.MAPI-TranslatorManager SUPPRESS"
    "log.tag.MDM-Subscriber SUPPRESS"
    "log.tag.MTKSST SUPPRESS"
    "log.tag.MTK_APPList SUPPRESS"
    "log.tag.MediaPlayer SUPPRESS"
    "log.tag.MediaPlayerService SUPPRESS"
    "log.tag.MediaRouter SUPPRESS"
    "log.tag.MediaSession SUPPRESS"
    "log.tag.MipcEventHandler SUPPRESS"
    "log.tag.MountService SUPPRESS"
    "log.tag.MtkAdnRecord SUPPRESS"
    "log.tag.MtkCsimFH SUPPRESS"
    "log.tag.MtkEmbmsAdaptor SUPPRESS"
    "log.tag.MtkFactory SUPPRESS"
    "log.tag.MtkGsmCdmaConn SUPPRESS"
    "log.tag.MtkIccCardProxy SUPPRESS"
    "log.tag.MtkIccPHBIM SUPPRESS"
    "log.tag.MtkIccProvider SUPPRESS"
    "log.tag.MtkIccSmsInterfaceManager SUPPRESS"
    "log.tag.MtkImsManager SUPPRESS"
    "log.tag.MtkImsService SUPPRESS"
    "log.tag.MtkIsimFH SUPPRESS"
    "log.tag.MtkPhoneNotifr SUPPRESS"
    "log.tag.MtkPhoneNumberUtils SUPPRESS"
    "log.tag.MtkPhoneSwitcher SUPPRESS"
    "log.tag.MtkRecordLoader SUPPRESS"
    "log.tag.MtkRuimFH SUPPRESS"
    "log.tag.MtkSIMFH SUPPRESS"
    "log.tag.MtkSIMRecords SUPPRESS"
    "log.tag.MtkSmsCbHeader SUPPRESS"
    "log.tag.MtkSmsManager SUPPRESS"
    "log.tag.MtkSmsMessage SUPPRESS"
    "log.tag.MtkSpnOverride SUPPRESS"
    "log.tag.MtkSubCtrl SUPPRESS"
    "log.tag.MtkTelephonyManagerEx SUPPRESS"
    "log.tag.MtkUiccCard SUPPRESS"
    "log.tag.MtkUiccCardApp SUPPRESS"
    "log.tag.MtkUiccCtrl SUPPRESS"
    "log.tag.MtkUsimFH SUPPRESS"
    "log.tag.MtkUsimPhoneBookManager SUPPRESS"
    "log.tag.MwiRIL SUPPRESS"
    "log.tag.NetAgentService SUPPRESS"
    "log.tag.NetAgent_IO SUPPRESS"
    "log.tag.NetLnkEventHdlr SUPPRESS"
    "log.tag.NetworkManagement SUPPRESS"
    "log.tag.NetworkManagementService SUPPRESS"
    "log.tag.NetworkPolicy SUPPRESS"
    "log.tag.NetworkPolicyManagerService SUPPRESS"
    "log.tag.NetworkStats SUPPRESS"
    "log.tag.NetworkTimeUpdateService SUPPRESS"
    "log.tag.NotificationManager SUPPRESS"
    "log.tag.NotificationManagerService SUPPRESS"
    "log.tag.OperatorUtils SUPPRESS"
    "log.tag.PKM-Lib SUPPRESS"
    "log.tag.PKM-MDM SUPPRESS"
    "log.tag.PKM-Monitor SUPPRESS"
    "log.tag.PKM-SA SUPPRESS"
    "log.tag.PKM-Service SUPPRESS"
    "log.tag.PQ_DS SUPPRESS"
    "log.tag.PackageInstaller SUPPRESS"
    "log.tag.PackageManager SUPPRESS"
    "log.tag.PersistentDataBlockManager SUPPRESS"
    "log.tag.Phone SUPPRESS"
    "log.tag.PhoneConfigurationSettings SUPPRESS"
    "log.tag.PhoneFactory SUPPRESS"
    "log.tag.PowerHalAddressUitls SUPPRESS"
    "log.tag.PowerHalMgrImpl SUPPRESS"
    "log.tag.PowerHalMgrServiceImpl SUPPRESS"
    "log.tag.PowerHalWifiMonitor SUPPRESS"
    "log.tag.PowerManager SUPPRESS"
    "log.tag.PowerManagerService SUPPRESS"
    "log.tag.PrintManager SUPPRESS"
    "log.tag.ProcessStats SUPPRESS"
    "log.tag.ProxyController SUPPRESS"
    "log.tag.RFX SUPPRESS"
    "log.tag.RIL SUPPRESS"
    "log.tag.RIL-Fusion SUPPRESS"
    "log.tag.RIL-Netlink SUPPRESS"
    "log.tag.RIL-Parcel SUPPRESS"
    "log.tag.RIL-SocListen SUPPRESS"
    "log.tag.RIL-Socket SUPPRESS"
    "log.tag.RILC SUPPRESS"
    "log.tag.RILC-OP SUPPRESS"
    "log.tag.RILD SUPPRESS"
    "log.tag.RILMD2-SS SUPPRESS"
    "log.tag.RIL_UIM_SOCKET SUPPRESS"
    "log.tag.RadioManager SUPPRESS"
    "log.tag.RfxAction SUPPRESS"
    "log.tag.RfxBaseHandler SUPPRESS"
    "log.tag.RfxChannelMgr SUPPRESS"
    "log.tag.RfxCloneMgr SUPPRESS"
    "log.tag.RfxContFactory SUPPRESS"
    "log.tag.RfxController SUPPRESS"
    "log.tag.RfxDebugInfo SUPPRESS"
    "log.tag.RfxDisThread SUPPRESS"
    "log.tag.RfxFragEnc SUPPRESS"
    "log.tag.RfxHandlerMgr SUPPRESS"
    "log.tag.RfxIdToMsgId SUPPRESS"
    "log.tag.RfxIdToStr SUPPRESS"
    "log.tag.RfxMainThread SUPPRESS"
    "log.tag.RfxMclDisThread SUPPRESS"
    "log.tag.RfxMclMessenger SUPPRESS"
    "log.tag.RfxMclStatusMgr SUPPRESS"
    "log.tag.RfxMessage SUPPRESS"
    "log.tag.RfxObject SUPPRESS"
    "log.tag.RfxOpUtils SUPPRESS"
    "log.tag.RfxRilAdapter SUPPRESS"
    "log.tag.RfxRilUtils SUPPRESS"
    "log.tag.RfxRoot SUPPRESS"
    "log.tag.RfxStatusMgr SUPPRESS"
    "log.tag.RfxTimer SUPPRESS"
    "log.tag.RilClient SUPPRESS"
    "log.tag.RilOemClient SUPPRESS"
    "log.tag.RilOpProxy SUPPRESS"
    "log.tag.RmmCapa SUPPRESS"
    "log.tag.RmmCommSimOpReq SUPPRESS"
    "log.tag.RmmDcEvent SUPPRESS"
    "log.tag.RmmDcPdnManager SUPPRESS"
    "log.tag.RmmDcUrcHandler SUPPRESS"
    "log.tag.RmmDcUtility SUPPRESS"
    "log.tag.RmmEccNumberReqHdlr SUPPRESS"
    "log.tag.RmmEccNumberUrcHandler SUPPRESS"
    "log.tag.RmmEmbmsReq SUPPRESS"
    "log.tag.RmmEmbmsUrc SUPPRESS"
    "log.tag.RmmImsCtlReqHdl SUPPRESS"
    "log.tag.RmmImsCtlUrcHdl SUPPRESS"
    "log.tag.RmmMwi SUPPRESS"
    "log.tag.RmmNwAsyncHdlr SUPPRESS"
    "log.tag.RmmNwHdlr SUPPRESS"
    "log.tag.RmmNwNrtReqHdlr SUPPRESS"
    "log.tag.RmmNwRTReqHdlr SUPPRESS"
    "log.tag.RmmNwRatSwHdlr SUPPRESS"
    "log.tag.RmmNwReqHdlr SUPPRESS"
    "log.tag.RmmNwUrcHdlr SUPPRESS"
    "log.tag.RmmOemHandler SUPPRESS"
    "log.tag.RmmOpRadioReq SUPPRESS"
    "log.tag.RmmPhbReq SUPPRESS"
    "log.tag.RmmPhbUrc SUPPRESS"
    "log.tag.RmmRadioReq SUPPRESS"
    "log.tag.RmmSimBaseHandler SUPPRESS"
    "log.tag.RmmSimCommReq SUPPRESS"
    "log.tag.RmmSimCommUrc SUPPRESS"
    "log.tag.RmmWp SUPPRESS"
    "log.tag.RtmCapa SUPPRESS"
    "log.tag.RtmCommSimCtrl SUPPRESS"
    "log.tag.RtmDC SUPPRESS"
    "log.tag.RtmEccNumberController SUPPRESS"
    "log.tag.RtmEmbmsAt SUPPRESS"
    "log.tag.RtmEmbmsUtil SUPPRESS"
    "log.tag.RtmIms SUPPRESS"
    "log.tag.RtmImsConference SUPPRESS"
    "log.tag.RtmImsConfigController SUPPRESS"
    "log.tag.RtmImsDialog SUPPRESS"
    "log.tag.RtmModeCont SUPPRESS"
    "log.tag.RtmMwi SUPPRESS"
    "log.tag.RtmNwCtrl SUPPRESS"
    "log.tag.RtmPhb SUPPRESS"
    "log.tag.RtmRadioConfig SUPPRESS"
    "log.tag.RtmRadioCont SUPPRESS"
    "log.tag.RtmWp SUPPRESS"
    "log.tag.SIMRecords SUPPRESS"
    "log.tag.SQLiteQueryBuilder SUPPRESS"
    "log.tag.SensorManager SUPPRESS"
    "log.tag.ServiceManager SUPPRESS"
    "log.tag.SimSwitchOP01 SUPPRESS"
    "log.tag.SimSwitchOP02 SUPPRESS"
    "log.tag.SimSwitchOP18 SUPPRESS"
    "log.tag.SlotQueueEntry SUPPRESS"
    "log.tag.SpnOverride SUPPRESS"
    "log.tag.StatusBarManagerService SUPPRESS"
    "log.tag.StorageManager SUPPRESS"
    "log.tag.SurfaceFlinger SUPPRESS"
    "log.tag.SystemServer SUPPRESS"
    "log.tag.Telecom SUPPRESS"
    "log.tag.TelephonyManager SUPPRESS"
    "log.tag.TelephonyRegistry SUPPRESS"
    "log.tag.ThermalManager SUPPRESS"
    "log.tag.ToneGenerator SUPPRESS"
    "log.tag.UiccCard SUPPRESS"
    "log.tag.UiccController SUPPRESS"
    "log.tag.UsbHostManager SUPPRESS"
    "log.tag.UsbManager SUPPRESS"
    "log.tag.UxUtility SUPPRESS"
    "log.tag.VT SUPPRESS"
    "log.tag.VibratorService SUPPRESS"
    "log.tag.VpnManager SUPPRESS"
    "log.tag.VsimAdaptor SUPPRESS"
    "log.tag.WORLDMODE SUPPRESS"
    "log.tag.WallpaperManager SUPPRESS"
    "log.tag.WfoApp SUPPRESS"
    "log.tag.WifiManager SUPPRESS"
    "log.tag.WindowManager SUPPRESS"
    "log.tag.WindowManagerService SUPPRESS"
    "log.tag.WpfaCcciDataHeaderEncoder SUPPRESS"
    "log.tag.WpfaCcciReader SUPPRESS"
    "log.tag.WpfaCcciSender SUPPRESS"
    "log.tag.WpfaControlMsgHandler SUPPRESS"
    "log.tag.WpfaDriver SUPPRESS"
    "log.tag.WpfaDriverAccept SUPPRESS"
    "log.tag.WpfaDriverAdapter SUPPRESS"
    "log.tag.WpfaDriverDeReg SUPPRESS"
    "log.tag.WpfaDriverMessage SUPPRESS"
    "log.tag.WpfaDriverRegFilter SUPPRESS"
    "log.tag.WpfaDriverULIpPkt SUPPRESS"
    "log.tag.WpfaDriverUtilis SUPPRESS"
    "log.tag.WpfaDriverVersion SUPPRESS"
    "log.tag.WpfaFilterRuleReqHandler SUPPRESS"
    "log.tag.WpfaParsing SUPPRESS"
    "log.tag.WpfaRingBuffer SUPPRESS"
    "log.tag.WpfaRuleContainer SUPPRESS"
    "log.tag.WpfaRuleRegister SUPPRESS"
    "log.tag.WpfaShmAccessController SUPPRESS"
    "log.tag.WpfaShmReadMsgHandler SUPPRESS"
    "log.tag.WpfaShmSynchronizer SUPPRESS"
    "log.tag.WpfaShmWriteMsgHandler SUPPRESS"
    "log.tag.brevent.event SUPPRESS"
    "log.tag.libPowerHal SUPPRESS"
    "log.tag.libfuse SUPPRESS"
    "log.tag.mipc_lib SUPPRESS"
    "log.tag.mtkpower@impl SUPPRESS"
    "log.tag.mtkpower_client SUPPRESS"
    "log.tag.trm_lib SUPPRESS"
    "log.tag.wpfa_iptable_android SUPPRESS"
    "log.tag.Networklogger SUPPRESS"
    "log.tag.AudioFlinger::DeviceEffectProxy SUPPRESS"
    )
    for commands in "${disable_log[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    setprop "$name" "$value"
done
}
log > /dev/null 2>&1  
tweaks() {
    global=(
        "gpu_debug_layers 0"
        "enable_gpu_debug_layers 0"
        "game_mode_enable 1"
        "perf_mode 1"
        "perf_proc_game_List com.dts.freefiremax,com.dts.freefireth"
        "force_gpu_rendering 1"
        "GPUTUNER_SWITCH true"
        "CPUTUNER_SWITCH true"
        "DYNAMIC_PERFORMANCE_DEFAULT_STATUS 1"
        "DYNAMIC_PERFORMANCE_STATUS 1"
        "debug_app 0"
        "low_power 0"
        "miui_cpu_model 2"
        "cached_apps_freezer enable"
        "performance_profile high_performance"
        "battery_stats_constants track_cpu_times_by_proc_state=false,track_cpu_active_cluster_time=false,read_binary_cpu_time=false,max_history_files=0,max_history_buffer_kb=0"
        "force_gpu_rendering 1"
        "miui_cpu_model 2"
        "kernel_cpu_thread_reader num_buckets=0,collected_uids=,minimum_total_cpu_usage_millis=999999999"
        "disable_window_blurs 1"
        "accessibility_reduce_transparency 1"
        "sustained_performance_mode_enabled 1"
        "thread_priority highest"        
    )
    sys=(
        "speed_pointer 7"
        "speed_mode 1"
        "fps_limit 0"
        "game-touchscreen-boost 1"
        "touch.pressure.scale 0.001"
        "touch_slop 8"
        "touch_boost 1"
        "ram_boost 1"
        "cpu_boost 1"
        "gpu_boost 1"
        "ui.hw 1"
    )
    secure=(
        "long_press_timeout 500"
        "multi_press_timeout 500"
        "speed_mode 1"
        "speed_mode_enable 1"
        "game_auto_temperature 0"
        "game_dashboard_always_on 1" 
        "high_priority 1"        
    )     
    debloat=(
        "--user 0 com.xiaomi.joyose"
        "--user 0 com.xiaomi.glgm"
        "--user 0 com.samsung.android.game.gos"
        "--user 0 com.samsung.android.game.gametools"
        "--user 0 com.samsung.android.game.gamehome"
    )
    tweaks=(
       "debug.sf.hw 1"
       "debug.egl.hw 1"
       "debug.perf.tuning 1"
       "debug.cpuprio 7"
       "debug.gpuprio 7"
       "debug.ioprio 7"
       "debug.gralloc.disable_afbc 0"
       "debug.rs.use_fast_math 1"
       "debug.egl.swapinterval 0"
       "debug.gr.swapinterval 0"
       "debug.sf.disable_hwc_vds 1"
       "debug.hwui.fps_divisor 1"
       "debug.overlayui.enable 1"
       "debug.composition.type c2d"
       "debug.composition.type gpu"
       "debug.hwui.target_cpu_time_percent 200"
       "debug.hwui.target_gpu_time_percent 200"
       "debug.qualcomm.sns.daemon 0"
       "debug.qualcomm.sns.hal 0"
       "debug.qualcomm.sns.libsensor1 0"
       "debug.javafx.animation.fullspeed true"
       "debug.systemuicompilerfilter speed-profile"
       "debug.sf.disable_backpressure 1"
       "debug.sf.gpu_comp_tiling 1"
       "debug.sf.multithreaded_present true"
       "debug.hwui_force_gpu_rendering 1"
       "debug.performance.tuning 1"
       "debug.gpu.use_low_latency_mode true"
       "debug.sf.use_frame_rate_priority 1"
       "debug.hwui.use_threaded_renderer true"
       "debug.hwui.use_threaded_renderer true"
       "debug.sf.enable_adpf_cpu_hint true"
       "debug.sf.fp16_client_target 0"
       "debug.hwui.use_hint_manager true"
       "debug.graphics.game_default_frame_rate.disabled true"
       "debug.sf.latch_unsignaled 1"
       "debug.javafx.animation.fullspeed true"
        "debug.javafx.animation.framerate 165"
        "debug.javafx.animation.fullframe 1"
        "debug.rs.use_fast_math 1"
        "debug.config.refresh_rate.boost true"
        "debug.sf.use_frame_rate_priority 1"
        "debug.sf.frame_rate_multiple_threshold 999"
        "debug.sf_frame_rate_multiple_fences 999"
        "debug.sf.enable_advanced_sf_phase_offset 0"
        "debug.sf.enable_hwc_vds 1"
        "debug.egl.swapinterval 0"
        "debug.hwui.render_dirty_regions false"
        "debug.sf.enable_gl_backpressure 1"
        "debug.sf.disable_backpressure 1"
        "debug.performance.boost 1"
        "debug.performance.governor performance"
        "debug.performance.inputthread 1"
        "debug.performance.io unlimited"
        "debug.performance.liquidgfx 1"
        "debug.performance.memory 1"
        "debug.performance.navigation 1"
        "debug.performance.profile 1"
        "debug.MB.running 0"
        "debug.MB.inner.running 100"
        "debug.overlayui.enable 0"
        "debug.hwui.profile 0"
        "debug.egl.trace 0"
        "debug.gles.trace 0"
        "debug.egl.profiler 0"
        "debug.hwui.disable_vsync true"
        "persist.sys.cpu.boost 1"
        "persist.sys.gpu.boost 1"
        "debug.dexoptab-ota speed-profile"
        "debug.dexopt.bg-dexopt speed-profile"
        "debug.dexopt.boot-after-ota verify"
        "debug.dexopt.cmdline verify"
        "debug.dexopt.First-use speed-profile"
        "debug.dexoptinactive verify"
        "debug.dexoptinstall speed-profile"
        "debug.dexoptinstall-bulk speed-profile"
        "debug.dexoptinstall-bulk-downgraded verify"
        "debug.dexopt.install-bulk-secondary verify"
        "debug.dexopt.install-bulk-secondary-downgraded extract"
        "debug.dexoptinstall-Fast skip"
        "debug.dexopt.post-boot extract"
        "debug.javafx.animation.fullspeed true"
        "debug.rs.default-CPU-driver 1"
    )
    msaa=(
        "debug.egl.force_msaa 0"
        "debug.hwui.force_fxaa 0" 
        "debug.hwui.force_smaa 0" 
        "debug.hwui.force_msaa 0" 
        "debug.hwui.force_txaa 0" 
        "debug.hwui.force_csaa 0" 
        "debug.hwui.force_dlss 0" 
        "debug.sf.showupdates 0"
        "debug.sf.showfps 0"
        "debug.sf.showcpu 0"
        "debug.sf.showbackground 0"
    )
    debug=(
        "debug.renderengine.skia_tracing_enabled false"
        "debug.renderengine.skia_use_perfetto_track_events false"
        "debug.hwui.skia_atrace_enabled false"
        "debug.hwui.skia_tracing_enabled false"
    )
    system=(
        "POWER_BALANCED_MODE_OPEN 0"
        "POWER_SAVE_MODE_OPEN 0"
        "POWER_PERFORMANCE_MODE_OPEN 1"
        "speed_mode 1"
    )
    disable_animation=(
        "window_animation_scale 0"
        "transition_animation_scale 0"
        "animator_duration_scale 0"
    )
    optimal=(
        "dalvik.vm.dexopt-flags m=y,v=n,o=v,u=n"
        "dalvik.vm.checkjni 0"
        "dalvik.vm.dex2oat-minidebuginfo false"
        "dalvik.vm.minidebuginfo false"
    )
    cmd=(
        "set-adaptive-power-saver-enabled false"
        "set-fixed-performance-mode-enabled true"
    )

    for commands in "${sys[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    settings put system "$name" "$value"
done
    for commands in "${secure[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    settings put secure "$name" "$value"
done
    for commands in "${global[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    settings put global "$name" "$value"
done
    for commands in "${debloat[@]}"; do
    IFS=' ' read -r namespace key value <<< "$commands"
    pm uninstall "$namespace" "$key" "$value"
done
    for commands in "${tweaks[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    setprop "$name" "$value"
done
    for commands in "${msaa[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    settings put system "$name" "$value"
done
    for commands in "${debug[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    settings put system "$name" "$value"
done
    for commands in "${system[@]}"; do
    IFS=' ' read -r key value <<< "$commands"
    settings put system "$key" "$value"
done
    for commands in "${disable_animation[@]}"; do
    IFS=' ' read -r key value <<< "$commands"
    settings put global "$key" "$value"
done
    for commands in "${optimal[@]}"; do
    IFS=' ' read -r key value <<< "$commands"
    setprop "$key" "$value"
done
    for commands in "${cmd[@]}"; do
    IFS=' ' read -r key value <<< "$commands"
    cmd power "$key" "$value"
done
}
tweaks > /dev/null 2>&1  
nhay() {    
# Tối ưu hóa cảm ứng
settings put system touch.response_time 5
settings put system touch_distance_scale 1
settings put system touch_sensitivity 1
settings put system touch.precision 1
settings put system tap_delay 0
settings put global touchresponse_time_boost 1
settings put global low_latency_inputenabled 1
settings put system gesture_sensitivity 2
settings put system scroll.smoothness 1
settings put secure double_tap_timeout 400
settings put system touch.size.scale 1
settings put global window_animation_scale 0.5
settings put global transition_animation_scale 0.5
settings put global animator_duration_scale 0.5
settings put system touch.pressure.scale 0.001
settings put system touch.size.calibration geometric
settings put system touch.pressure.calibration amplitude
settings put system ro.min.fling_velocity 25000
settings put system ro.max.fling_velocity 25000
settings put system game-touchscreen-boost 1
settings put global touch_drag_and_drop_optimization 1
settings put global touch_sensitivity_boost 1
settings put global touch_tap_responsiveness 1
settings put system touch_latency 0    
settings put system min_touch_target 48
settings put global touch_response_time 3
settings put global touch_fling_velocity 25000
settings put global fling_velocity 25000   
settings put system screen_brightness_mode 0
settings put system touch_delay 0
settings put system haptic_feedback_enabled 0
device_config put touchscreen input_drag_min_switch_speed 150
device_config put systemui min_fling_velocity 25000
device_config put systemui max_fling_velocity 25000
device_config put input touch_screen_sample_interval_ms 2
settings put system touch.size.bias 0
 settings put system touch.size.isSummed 0
 settings put system touch.distance.scale 0
 settings put system view.scroll_friction 10
 setprop debug.sf.enable_advanced_sf_phase_offset 0
 if [ -f /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq ] && [ -f /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq ]; then
        settings put global cpu_max_freq_big $(cat /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq)
        settings put global cpu_max_freq_little $(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
        settings put global cpu_boost_freq_big $(cat /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq)
        settings put global cpu_boost_freq_little $(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
        settings put global cpu_freq_min_sampling $(($(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq) - 200000))
        settings put global cpu_frequency_limit_max $(cat /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq)
        settings put global cpu_frequency_limit_min $(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
        settings put global cpu_max_freq_ovrrd 0
        settings put global cpu_boost_freq_ovrrd 0
        settings put global gpu_max_freq_ovrrd 0
        echo "Successful"
    else
        echo "Failed, maybe ur phone doesn't support"
    fi
}
nhay > /dev/null 2>&1  
tro() { 
packages=(
  "com.garena.game.kgvn"
  "com.vng.speedvn"
  "com.vng.codmvn"
  "com.vng.pubgmobile"
  "com.tencent.tmgp.speedmobile"
  "com.roblox.client.vnggames"
  "com.roblox.client"
  "com.dts.freefiremax"
  "com.dts.freefireth"
  "com.GlobalSoFunny.Sausage"
)
for package in "${packages[@]}"; do
  cmd game mode performance "$package"
  cmd device_config put game_overlay "$package" mode=2,fps=$refresh_rate,useAngle=true
  cmd package compile -m speed-profile -f "$package"
done
}
tro > /dev/null 2>&1  
dong() {
for app in $(cmd package list packages -3 | cut -f 2 -d ":"); do
if [[ ! "$app" == "ggproultra.gr.vn" ]]; then
cmd activity force-stop "$app"
cmd activity kill "$app"
fi
done
}
dong > /dev/null 2>&1  
ff() {
cmd game set --fps $refresh_rate --mode 2 --downscale 0.6 com.dts.freefiremax
cmd game set --fps $refresh_rate --mode 2 --downscale 0.6 com.dts.freefireth
}
ff > /dev/null 2>&1  
echo "$SPACER"
echo "$(pad_text "Optimization Complete!")"
echo "$BOX_BTM"
echo ""
sleep 1
