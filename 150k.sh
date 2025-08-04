#!/system/bin/sh
# Định nghĩa các biến giao diện
DIVIDER="=========================================="
SECTION_DIV="=========================================="
PROGRESS_DIV="--> "
PROGRESS_MARK="> "
# Hàm căn giữa văn bản
pad_text() {
    local text="$1"
    local width=40
    local len=${#text}
    local total_padding=$((width - len))
    local left_pad_len=$((total_padding / 2))
    local right_pad_len=$((total_padding - left_pad_len)) # Đảm bảo tổng bằng total_padding
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

    echo "$left_pad$text$right_pad"
}
# Bắt đầu giao diện
clear
echo "$DIVIDER"
echo "$HEADER_MARK$(pad_text "PerGRV1 Optimizer")$HEADER_MARK"
echo "$SECTION_DIV"
echo " $(pad_text "Game Performance Booster")"
echo "$DIVIDER"
echo " Developer: GRAP FIFA"
echo " YouTube : GRAP FIFA"
echo " TikTok  : GRAP FIFA"
echo " Contact : Thang Le (Zalo)"
if [ "$(id -u)" -eq 0 ] || which su >/dev/null 2>&1; then
    echo " Device  : Rooted"
    root_status="root"
else
    echo " Device  : Non-Rooted"
    root_status="not_root"
fi
echo " Module  : PerGRV1 VIP"
echo " Version : 1.0"
echo " Powered : GRAP FIFA AKZ Team"
echo "$DIVIDER"
echo ""
sleep 1

# Phân tích hệ thống
echo "$SECTION_DIV"
echo "$HEADER_MARK$(pad_text "System Analysis")$HEADER_MARK"
echo "$SECTION_DIV"
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
echo "$DIVIDER"
echo "$HEADER_MARK$(pad_text "DEVICE INFO")$HEADER_MARK"
echo "$SECTION_DIV"
echo " Model      : ${device_name}" | cut -c 1-40
sleep 0.3
echo " Brand      : ${manufacturer}" | cut -c 1-40
sleep 0.3
echo " Android    : ${adr_version}" | cut -c 1-40
echo " Build      : ${adr_build}" | cut -c 1-40
echo " Locale     : ${product_locale}" | cut -c 1-40
echo " Kernel     : ${kernel_version}" | cut -c 1-40
echo " RAM Total  : ${total_ram}" | cut -c 1-40
echo " RAM Free   : ${free_ram} MB" | cut -c 1-40
echo " CPU Arch   : ${cpu_abi} (${bit})" | cut -c 1-40
echo " Chipset    : ${check_chip}" | cut -c 1-40
echo " GPU        : ${gpu_info}" | cut -c 1-40
echo " Vulkan     : ${vulkan}" | cut -c 1-40
echo "$DIVIDER"
echo ""
sleep 1

# Giả lập quá trình tối ưu hóa
echo "$SECTION_DIV"
echo "🚀$(pad_text "Optimizing System")🚀"
echo "$SECTION_DIV"
echo "$PROGRESS_DIV[1/4] Scanning System...      $PROGRESS_MARK"
sleep 0.5
echo "$PROGRESS_DIV[2/4] Clearing Cache...      $PROGRESS_MARK"
sleep 0.5
echo "$PROGRESS_DIV[3/4] Boosting CPU/GPU...    $PROGRESS_MARK"
sleep 0.5
echo "$PROGRESS_DIV[4/4] Finalizing...         $PROGRESS_MARK"
echo ""
sleep 1
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
        echo "$PROGRESS_DIV ${STICKER_ERROR}Refresh rate $refresh_rate not supported."
        exit 1
        ;;
esac

echo "Tần số quét phát hiện: $refresh_rate Hz"

case "$refresh_rate" in
  60)
    frame_ns=16666667
    phazev2=1984000
    phazev4=4762000
    phazev5=5596000
    phazev6=9200000
    phazev7=17540000
    hwc_duration=21666667
    ;;
  90)
    frame_ns=11111111
    phazev2=1322798
    phazev4=3174603
    phazev5=3728597
    phazev6=6132605
    phazev7=11701064
    hwc_duration=14444444
    ;;
  120)
    frame_ns=8333333
    phazev2=991101
    phazev4=2380952
    phazev5=2800000
    phazev6=4601845
    phazev7=8771930
    hwc_duration=10833333
    ;;
  144)
    frame_ns=6944444
    phazev2=826718
    phazev4=2026984
    phazev5=2373892
    phazev6=3900552
    phazev7=7425736
    hwc_duration=9027777
    ;;
  *)
    echo "Không hỗ trợ tần số quét này ($refresh_rate Hz). Thoát."
    exit 1
    ;;
esac

setprop debug.sf.hwc.min.duration $hwc_duration
setprop debug.sf.early_app_phase_offset_ns $phazev2
setprop debug.sf.early_gl_app_phase_offset_ns $phazev2
setprop debug.sf.early_phase_offset_ns $phazev5
setprop debug.sf.early_gl_phase_offset_ns $phazev5
setprop debug.sf.late.app.duration $phazev6
setprop debug.sf.late.sf.duration $phazev6
setprop debug.sf.early.app.duration $phazev4
setprop debug.sf.early.sf.duration $phazev4
setprop debug.sf.cached_set_render_duration_ns $phazev4
setprop debug.sf.region_sampling_duration_ns $phazev4
setprop debug.sf.region_sampling_timer_timeout_ns $phazev7
setprop debug.sf.region_sampling_period_ns $phazev6
setprop debug.sf.phase_offset_threshold_for_next_vsync_ns $phazev6
echo "  [1/3] Applied Display Optimization for ${refresh_rate}Hz"
#Tối ưu ram
get_ram_gb() {
    mem_kb=$(grep -i MemTotal /proc/meminfo | awk '{print $2}')
    mem_gb=$(( (mem_kb + 1048575) / 1048576 )) # Làm tròn lên GB
    echo "$mem_gb"
}

apply_config() {
    ram_gb=$1
    echo "  Detected RAM: ${ram_gb}GB"

    if [ "$ram_gb" -le 2 ]; then
        echo "  Applying Config for Low RAM (≤2GB)"
        settings put global activity_manager_constants max_cached_processes=48,CUR_MAX_CACHED_PROCESSES=96,CUR_MAX_EMPTY_PROCESSES=32,CUR_TRIM_EMPTY_PROCESSES=24,CUR_TRIM_CACHED_PROCESSES=32,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=2,MULTI_THREAD_CPU=false,power_check_max_cpu_1=90,power_check_max_cpu_2=80,power_check_max_cpu_3=60,power_check_max_cpu_4=50,power_check_max_gpu=85,max_empty_time_millis=180000,max_phantom_processes=4,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 4096
        setprop debug.hwui.layer_cache_size 4096
        setprop debug.hwui.pipeline_cache_size 4096
        setprop debug.hwui.fbo_cache_size 3072
        setprop debug.hwui.cache_size 4096

    elif [ "$ram_gb" -le 3 ]; then
        echo "  Applying Config for 3GB RAM"
        settings put global activity_manager_constants max_cached_processes=64,CUR_MAX_CACHED_PROCESSES=128,CUR_MAX_EMPTY_PROCESSES=48,CUR_TRIM_EMPTY_PROCESSES=32,CUR_TRIM_CACHED_PROCESSES=48,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=2,MULTI_THREAD_CPU=true,power_check_max_cpu_1=92,power_check_max_cpu_2=85,power_check_max_cpu_3=65,power_check_max_cpu_4=55,power_check_max_gpu=87,max_empty_time_millis=180000,max_phantom_processes=5,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 6144
        setprop debug.hwui.layer_cache_size 6144
        setprop debug.hwui.pipeline_cache_size 6144
        setprop debug.hwui.fbo_cache_size 4096
        setprop debug.hwui.cache_size 5120

    elif [ "$ram_gb" -le 4 ]; then
        echo "  Applying Config for 4GB RAM"
        settings put global activity_manager_constants max_cached_processes=96,CUR_MAX_CACHED_PROCESSES=256,CUR_MAX_EMPTY_PROCESSES=64,CUR_TRIM_EMPTY_PROCESSES=48,CUR_TRIM_CACHED_PROCESSES=64,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=6,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 8192
        setprop debug.hwui.layer_cache_size 8192
        setprop debug.hwui.pipeline_cache_size 8192
        setprop debug.hwui.fbo_cache_size 6144
        setprop debug.hwui.cache_size 7168

    elif [ "$ram_gb" -le 6 ]; then
        echo "  Applying Config for 6GB RAM"
        settings put global activity_manager_constants max_cached_processes=128,CUR_MAX_CACHED_PROCESSES=320,CUR_MAX_EMPTY_PROCESSES=96,CUR_TRIM_EMPTY_PROCESSES=64,CUR_TRIM_CACHED_PROCESSES=96,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=8,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 10240
        setprop debug.hwui.layer_cache_size 10240
        setprop debug.hwui.pipeline_cache_size 10240
        setprop debug.hwui.fbo_cache_size 8192
        setprop debug.hwui.cache_size 9216

    elif [ "$ram_gb" -le 8 ]; then
        echo "  Applying Config for 8GB RAM"
        settings put global activity_manager_constants max_cached_processes=160,CUR_MAX_CACHED_PROCESSES=384,CUR_MAX_EMPTY_PROCESSES=128,CUR_TRIM_EMPTY_PROCESSES=96,CUR_TRIM_CACHED_PROCESSES=128,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=10,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 12288
        setprop debug.hwui.layer_cache_size 12288
        setprop debug.hwui.pipeline_cache_size 12288
        setprop debug.hwui.fbo_cache_size 10240
        setprop debug.hwui.cache_size 11264
    elif [ "$ram_gb" -le 12 ]; then
        echo "  Applying Config for 12GB RAM"
        settings put global activity_manager_constants max_cached_processes=224,CUR_MAX_CACHED_PROCESSES=512,CUR_MAX_EMPTY_PROCESSES=160,CUR_TRIM_EMPTY_PROCESSES=128,CUR_TRIM_CACHED_PROCESSES=160,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=4,MULTI_THREAD_CPU=true,power_check_max_cpu_1=97,power_check_max_cpu_2=94,power_check_max_cpu_3=78,power_check_max_cpu_4=68,power_check_max_gpu=93,max_empty_time_millis=150000,max_phantom_processes=14,service_timeout=10000,bg_start_timeout=7000,gc_timeout=5000,content_provider_retain_time=3000

        setprop debug.hwui.texture_cache_size 16384
        setprop debug.hwui.layer_cache_size 16384
        setprop debug.hwui.pipeline_cache_size 16384
        setprop debug.hwui.fbo_cache_size 14336
        setprop debug.hwui.cache_size 15360

    elif [ "$ram_gb" -le 16 ]; then
        echo "  Applying Config for 16GB RAM"
        settings put global activity_manager_constants max_cached_processes=256,CUR_MAX_CACHED_PROCESSES=576,CUR_MAX_EMPTY_PROCESSES=192,CUR_TRIM_EMPTY_PROCESSES=160,CUR_TRIM_CACHED_PROCESSES=192,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=4,MULTI_THREAD_CPU=true,power_check_max_cpu_1=98,power_check_max_cpu_2=95,power_check_max_cpu_3=80,power_check_max_cpu_4=70,power_check_max_gpu=94,max_empty_time_millis=150000,max_phantom_processes=16,service_timeout=9000,bg_start_timeout=6000,gc_timeout=5000,content_provider_retain_time=3000

        setprop debug.hwui.texture_cache_size 20480
        setprop debug.hwui.layer_cache_size 20480
        setprop debug.hwui.pipeline_cache_size 20480
        setprop debug.hwui.fbo_cache_size 16384
        setprop debug.hwui.cache_size 18432

    elif [ "$ram_gb" -ge 17 ]; then
        echo "  Applying Config for High-End RAM (≥17GB)"
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
    echo " [2/3] RAM Optimization Completed ${STICKER_PROGRESS}"
}

main() {
    ram=$(get_ram_gb)
    apply_config "$ram"
}
main
sleep 1
dumpsys battery reset
log() {
setprop log.tag.AF::MmapTrack SUPPRESS
setprop log.tag.AF::OutputTrack SUPPRESS
setprop log.tag.AF::PatchRecord SUPPRESS
setprop log.tag.AF::PatchTrack SUPPRESS
setprop log.tag.AF::RecordHandle SUPPRESS
setprop log.tag.AF::RecordTrack SUPPRESS
setprop log.tag.AF::Track SUPPRESS
setprop log.tag.AF::TrackBase SUPPRESS
setprop log.tag.AF::TrackHandle SUPPRESS
setprop log.tag.APM-KpiMonitor SUPPRESS
setprop log.tag.APM-ServiceJ SUPPRESS
setprop log.tag.APM-SessionJ SUPPRESS
setprop log.tag.APM-SessionN SUPPRESS
setprop log.tag.APM-Subscriber SUPPRESS
setprop log.tag.APM::AudioCollections SUPPRESS
setprop log.tag.APM::AudioInputDescriptor SUPPRESS
setprop log.tag.APM::AudioOutputDescriptor SUPPRESS
setprop log.tag.APM::AudioPatch SUPPRESS
setprop log.tag.APM::AudioPolicyEngine SUPPRESS
setprop log.tag.APM::AudioPolicyEngine::Base SUPPRESS
setprop log.tag.APM::AudioPolicyEngine::Config SUPPRESS
setprop log.tag.APM::AudioPolicyEngine::ProductStrategy SUPPRESS
setprop log.tag.APM::AudioPolicyEngine::VolumeGroup SUPPRESS
setprop log.tag.APM::Devices SUPPRESS
setprop log.tag.APM::IOProfile SUPPRESS
setprop log.tag.APM::Serializer SUPPRESS
setprop log.tag.APM::VolumeCurve SUPPRESS
setprop log.tag.APM_AudioPolicyManager SUPPRESS
setprop log.tag.APM_ClientDescriptor SUPPRESS
setprop log.tag.AT SUPPRESS
setprop log.tag.AccountManager SUPPRESS
setprop log.tag.ActivityManager SUPPRESS
setprop log.tag.ActivityManagerService SUPPRESS
setprop log.tag.ActivityTaskManager SUPPRESS
setprop log.tag.ActivityTaskManagerService SUPPRESS
setprop log.tag.AdnRecord SUPPRESS
setprop log.tag.AdnRecordCache SUPPRESS
setprop log.tag.AdnRecordLoader SUPPRESS
setprop log.tag.AirplaneHandler SUPPRESS
setprop log.tag.AlarmManager SUPPRESS
setprop log.tag.AlarmManagerService SUPPRESS
setprop log.tag.AndroidRuntime SUPPRESS
setprop log.tag.AppOps SUPPRESS
setprop log.tag.AudioAttributes SUPPRESS
setprop log.tag.AudioEffect SUPPRESS
setprop log.tag.AudioFlinger SUPPRESS
setprop log.tag.AudioFlinger::DeviceEffectProxy SUPPRESS
setprop log.tag.AudioFlinger::DeviceEffectProxy::ProxyCallback SUPPRESS
setprop log.tag.AudioFlinger::EffectBase SUPPRESS
setprop log.tag.AudioFlinger::EffectChain SUPPRESS
setprop log.tag.AudioFlinger::EffectHandle SUPPRESS
setprop log.tag.AudioFlinger::EffectModule SUPPRESS
setprop log.tag.AudioFlinger_Threads SUPPRESS
setprop log.tag.AudioHwDevice SUPPRESS
setprop log.tag.AudioManager SUPPRESS
setprop log.tag.AudioPolicy SUPPRESS
setprop log.tag.AudioPolicyEffects SUPPRESS
setprop log.tag.AudioPolicyIntefaceImpl SUPPRESS
setprop log.tag.AudioPolicyManager SUPPRESS
setprop log.tag.AudioPolicyService SUPPRESS
setprop log.tag.AudioProductStrategy SUPPRESS
setprop log.tag.AudioRecord SUPPRESS
setprop log.tag.AudioService SUPPRESS
setprop log.tag.AudioSystem SUPPRESS
setprop log.tag.AudioTrack SUPPRESS
setprop log.tag.AudioTrackShared SUPPRESS
setprop log.tag.AudioVolumeGroup SUPPRESS
setprop log.tag.BackupManager SUPPRESS
setprop log.tag.BatteryManager SUPPRESS
setprop log.tag.BatteryStatsService SUPPRESS
setprop log.tag.BluetoothAdapter SUPPRESS
setprop log.tag.BluetoothDevice SUPPRESS
setprop log.tag.BluetoothGattService SUPPRESS
setprop log.tag.BluetoothHidService SUPPRESS
setprop log.tag.BluetoothManager SUPPRESS
setprop log.tag.BluetoothMapService SUPPRESS
setprop log.tag.BluetoothPanService SUPPRESS
setprop log.tag.BluetoothPbapService SUPPRESS
setprop log.tag.BluetoothSapService SUPPRESS
setprop log.tag.BluetoothService SUPPRESS
setprop log.tag.BluetoothSocket SUPPRESS
setprop log.tag.BufferQueueDump SUPPRESS
setprop log.tag.BufferQueueProducer SUPPRESS
setprop log.tag.C2K_AT SUPPRESS
setprop log.tag.C2K_ATConfig SUPPRESS
setprop log.tag.C2K_RILC SUPPRESS
setprop log.tag.CAM2PORT_ SUPPRESS
setprop log.tag.CapaSwitch SUPPRESS
setprop log.tag.CarrierExpressServiceImpl SUPPRESS
setprop log.tag.CarrierExpressServiceImplExt SUPPRESS
setprop log.tag.ClipboardManager SUPPRESS
setprop log.tag.ConnectivityManager SUPPRESS
setprop log.tag.ConnectivityService SUPPRESS
setprop log.tag.ConsumerIrService SUPPRESS
setprop log.tag.ContentManager SUPPRESS
setprop log.tag.CountryDetector SUPPRESS
setprop log.tag.DMC-ApmService SUPPRESS
setprop log.tag.DMC-Core SUPPRESS
setprop log.tag.DMC-DmcService SUPPRESS
setprop log.tag.DMC-EventsSubscriber SUPPRESS
setprop log.tag.DMC-ReqQManager SUPPRESS
setprop log.tag.DMC-SessionManager SUPPRESS
setprop log.tag.DMC-TranslatorLoader SUPPRESS
setprop log.tag.DMC-TranslatorUtils SUPPRESS
setprop log.tag.DSSelector SUPPRESS
setprop log.tag.DSSelectorOP01 SUPPRESS
setprop log.tag.DSSelectorOP02 SUPPRESS
setprop log.tag.DSSelectorOP09 SUPPRESS
setprop log.tag.DSSelectorOP18 SUPPRESS
setprop log.tag.DSSelectorOm SUPPRESS
setprop log.tag.DSSelectorUtil SUPPRESS
setprop log.tag.DataDispatcher SUPPRESS
setprop log.tag.DeviceIdleController SUPPRESS
setprop log.tag.DevicePolicyManager SUPPRESS
setprop log.tag.DevicePolicyManagerService SUPPRESS
setprop log.tag.DisplayManager SUPPRESS
setprop log.tag.DisplayManagerService SUPPRESS
setprop log.tag.DockObserver SUPPRESS
setprop log.tag.DownloadManager SUPPRESS
setprop log.tag.ExternalSimMgr SUPPRESS
setprop log.tag.FastCapture SUPPRESS
setprop log.tag.FastMixer SUPPRESS
setprop log.tag.FastMixerState SUPPRESS
setprop log.tag.FastThread SUPPRESS
setprop log.tag.FragmentManager SUPPRESS
setprop log.tag.FuseDaemon SUPPRESS
setprop log.tag.GAv4 SUPPRESS
setprop log.tag.GraphicsStats SUPPRESS
setprop log.tag.GsmCallTkrHlpr SUPPRESS
setprop log.tag.GsmCdmaConn SUPPRESS
setprop log.tag.GsmCdmaPhone SUPPRESS
setprop log.tag.HardwarePropertiesManager SUPPRESS
setprop log.tag.HardwareService SUPPRESS
setprop log.tag.IAudioFlinger SUPPRESS
setprop log.tag.IMSRILRequest SUPPRESS
setprop log.tag.IMS_RILA SUPPRESS
setprop log.tag.IccCardProxy SUPPRESS
setprop log.tag.IccPhoneBookIM SUPPRESS
setprop log.tag.IccProvider SUPPRESS
setprop log.tag.ImsApp SUPPRESS
setprop log.tag.ImsBaseCommands SUPPRESS
setprop log.tag.ImsCall SUPPRESS
setprop log.tag.ImsCallProfile SUPPRESS
setprop log.tag.ImsCallSession SUPPRESS
setprop log.tag.ImsEcbm SUPPRESS
setprop log.tag.ImsEcbmProxy SUPPRESS
setprop log.tag.ImsManager SUPPRESS
setprop log.tag.ImsPhone SUPPRESS
setprop log.tag.ImsPhoneBase SUPPRESS
setprop log.tag.ImsPhoneCall SUPPRESS
setprop log.tag.ImsService SUPPRESS
setprop log.tag.ImsVTProvider SUPPRESS
setprop log.tag.InputDispatcher SUPPRESS
setprop log.tag.InputManager SUPPRESS
setprop log.tag.InputManagerService SUPPRESS
setprop log.tag.InputMethodManager SUPPRESS
setprop log.tag.InputMethodManagerService SUPPRESS
setprop log.tag.InterfaceManager SUPPRESS
setprop log.tag.IsimFileHandler SUPPRESS
setprop log.tag.IsimRecords SUPPRESS
setprop log.tag.JobScheduler SUPPRESS
setprop log.tag.KeyguardManager SUPPRESS
setprop log.tag.LCM-Subscriber SUPPRESS
setprop log.tag.LIBC2K_RIL SUPPRESS
setprop log.tag.LocationManager SUPPRESS
setprop log.tag.LocationManagerService SUPPRESS
setprop log.tag.LocationProvider SUPPRESS
setprop log.tag.MAPI-CommandProcessor SUPPRESS
setprop log.tag.MAPI-MdiRedirector SUPPRESS
setprop log.tag.MAPI-MdiRedirectorCtrl SUPPRESS
setprop log.tag.MAPI-NetworkSocketConnection SUPPRESS
setprop log.tag.MAPI-SocketConnection SUPPRESS
setprop log.tag.MAPI-SocketListener SUPPRESS
setprop log.tag.MAPI-TranslatorManager SUPPRESS
setprop log.tag.MDM-Subscriber SUPPRESS
setprop log.tag.MTKSST SUPPRESS
setprop log.tag.MTK_APPList SUPPRESS
setprop log.tag.MediaPlayer SUPPRESS
setprop log.tag.MediaPlayerService SUPPRESS
setprop log.tag.MediaRouter SUPPRESS
setprop log.tag.MediaSession SUPPRESS
setprop log.tag.MipcEventHandler SUPPRESS
setprop log.tag.MountService SUPPRESS
setprop log.tag.MtkAdnRecord SUPPRESS
setprop log.tag.MtkCsimFH SUPPRESS
setprop log.tag.MtkEmbmsAdaptor SUPPRESS
setprop log.tag.MtkFactory SUPPRESS
setprop log.tag.MtkGsmCdmaConn SUPPRESS
setprop log.tag.MtkIccCardProxy SUPPRESS
setprop log.tag.MtkIccPHBIM SUPPRESS
setprop log.tag.MtkIccProvider SUPPRESS
setprop log.tag.MtkIccSmsInterfaceManager SUPPRESS
setprop log.tag.MtkImsManager SUPPRESS
setprop log.tag.MtkImsService SUPPRESS
setprop log.tag.MtkIsimFH SUPPRESS
setprop log.tag.MtkPhoneNotifr SUPPRESS
setprop log.tag.MtkPhoneNumberUtils SUPPRESS
setprop log.tag.MtkPhoneSwitcher SUPPRESS
setprop log.tag.MtkRecordLoader SUPPRESS
setprop log.tag.MtkRuimFH SUPPRESS
setprop log.tag.MtkSIMFH SUPPRESS
setprop log.tag.MtkSIMRecords SUPPRESS
setprop log.tag.MtkSmsCbHeader SUPPRESS
setprop log.tag.MtkSmsManager SUPPRESS
setprop log.tag.MtkSmsMessage SUPPRESS
setprop log.tag.MtkSpnOverride SUPPRESS
setprop log.tag.MtkSubCtrl SUPPRESS
setprop log.tag.MtkTelephonyManagerEx SUPPRESS
setprop log.tag.MtkUiccCard SUPPRESS
setprop log.tag.MtkUiccCardApp SUPPRESS
setprop log.tag.MtkUiccCtrl SUPPRESS
setprop log.tag.MtkUsimFH SUPPRESS
setprop log.tag.MtkUsimPhoneBookManager SUPPRESS
setprop log.tag.MwiRIL SUPPRESS
setprop log.tag.NetAgentService SUPPRESS
setprop log.tag.NetAgent_IO SUPPRESS
setprop log.tag.NetLnkEventHdlr SUPPRESS
setprop log.tag.NetworkManagement SUPPRESS
setprop log.tag.NetworkManagementService SUPPRESS
setprop log.tag.NetworkPolicy SUPPRESS
setprop log.tag.NetworkPolicyManagerService SUPPRESS
setprop log.tag.NetworkStats SUPPRESS
setprop log.tag.NetworkTimeUpdateService SUPPRESS
setprop log.tag.NotificationManager SUPPRESS
setprop log.tag.NotificationManagerService SUPPRESS
setprop log.tag.OperatorUtils SUPPRESS
setprop log.tag.PKM-Lib SUPPRESS
setprop log.tag.PKM-MDM SUPPRESS
setprop log.tag.PKM-Monitor SUPPRESS
setprop log.tag.PKM-SA SUPPRESS
setprop log.tag.PKM-Service SUPPRESS
setprop log.tag.PQ_DS SUPPRESS
setprop log.tag.PackageInstaller SUPPRESS
setprop log.tag.PackageManager SUPPRESS
setprop log.tag.PersistentDataBlockManager SUPPRESS
setprop log.tag.Phone SUPPRESS
setprop log.tag.PhoneConfigurationSettings SUPPRESS
setprop log.tag.PhoneFactory SUPPRESS
setprop log.tag.PowerHalAddressUitls SUPPRESS
setprop log.tag.PowerHalMgrImpl SUPPRESS
setprop log.tag.PowerHalMgrServiceImpl SUPPRESS
setprop log.tag.PowerHalWifiMonitor SUPPRESS
setprop log.tag.PowerManager SUPPRESS
setprop log.tag.PowerManagerService SUPPRESS
setprop log.tag.PrintManager SUPPRESS
setprop log.tag.ProcessStats SUPPRESS
setprop log.tag.ProxyController SUPPRESS
setprop log.tag.RFX SUPPRESS
setprop log.tag.RIL SUPPRESS
setprop log.tag.RIL-Fusion SUPPRESS
setprop log.tag.RIL-Netlink SUPPRESS
setprop log.tag.RIL-Parcel SUPPRESS
setprop log.tag.RIL-SocListen SUPPRESS
setprop log.tag.RIL-Socket SUPPRESS
setprop log.tag.RILC SUPPRESS
setprop log.tag.RILC-OP SUPPRESS
setprop log.tag.RILD SUPPRESS
setprop log.tag.RILMD2-SS SUPPRESS
setprop log.tag.RIL_UIM_SOCKET SUPPRESS
setprop log.tag.RadioManager SUPPRESS
setprop log.tag.RfxAction SUPPRESS
setprop log.tag.RfxBaseHandler SUPPRESS
setprop log.tag.RfxChannelMgr SUPPRESS
setprop log.tag.RfxCloneMgr SUPPRESS
setprop log.tag.RfxContFactory SUPPRESS
setprop log.tag.RfxController SUPPRESS
setprop log.tag.RfxDebugInfo SUPPRESS
setprop log.tag.RfxDisThread SUPPRESS
setprop log.tag.RfxFragEnc SUPPRESS
setprop log.tag.RfxHandlerMgr SUPPRESS
setprop log.tag.RfxIdToMsgId SUPPRESS
setprop log.tag.RfxIdToStr SUPPRESS
setprop log.tag.RfxMainThread SUPPRESS
setprop log.tag.RfxMclDisThread SUPPRESS
setprop log.tag.RfxMclMessenger SUPPRESS
setprop log.tag.RfxMclStatusMgr SUPPRESS
setprop log.tag.RfxMessage SUPPRESS
setprop log.tag.RfxObject SUPPRESS
setprop log.tag.RfxOpUtils SUPPRESS
setprop log.tag.RfxRilAdapter SUPPRESS
setprop log.tag.RfxRilUtils SUPPRESS
setprop log.tag.RfxRoot SUPPRESS
setprop log.tag.RfxStatusMgr SUPPRESS
setprop log.tag.RfxTimer SUPPRESS
setprop log.tag.RilClient SUPPRESS
setprop log.tag.RilOemClient SUPPRESS
setprop log.tag.RilOpProxy SUPPRESS
setprop log.tag.RmmCapa SUPPRESS
setprop log.tag.RmmCommSimOpReq SUPPRESS
setprop log.tag.RmmDcEvent SUPPRESS
setprop log.tag.RmmDcPdnManager SUPPRESS
setprop log.tag.RmmDcUrcHandler SUPPRESS
setprop log.tag.RmmDcUtility SUPPRESS
setprop log.tag.RmmEccNumberReqHdlr SUPPRESS
setprop log.tag.RmmEccNumberUrcHandler SUPPRESS
setprop log.tag.RmmEmbmsReq SUPPRESS
setprop log.tag.RmmEmbmsUrc SUPPRESS
setprop log.tag.RmmImsCtlReqHdl SUPPRESS
setprop log.tag.RmmImsCtlUrcHdl SUPPRESS
setprop log.tag.RmmMwi SUPPRESS
setprop log.tag.RmmNwAsyncHdlr SUPPRESS
setprop log.tag.RmmNwHdlr SUPPRESS
setprop log.tag.RmmNwNrtReqHdlr SUPPRESS
setprop log.tag.RmmNwRTReqHdlr SUPPRESS
setprop log.tag.RmmNwRatSwHdlr SUPPRESS
setprop log.tag.RmmNwReqHdlr SUPPRESS
setprop log.tag.RmmNwUrcHdlr SUPPRESS
setprop log.tag.RmmOemHandler SUPPRESS
setprop log.tag.RmmOpRadioReq SUPPRESS
setprop log.tag.RmmPhbReq SUPPRESS
setprop log.tag.RmmPhbUrc SUPPRESS
setprop log.tag.RmmRadioReq SUPPRESS
setprop log.tag.RmmSimBaseHandler SUPPRESS
setprop log.tag.RmmSimCommReq SUPPRESS
setprop log.tag.RmmSimCommUrc SUPPRESS
setprop log.tag.RmmWp SUPPRESS
setprop log.tag.RtmCapa SUPPRESS
setprop log.tag.RtmCommSimCtrl SUPPRESS
setprop log.tag.RtmDC SUPPRESS
setprop log.tag.RtmEccNumberController SUPPRESS
setprop log.tag.RtmEmbmsAt SUPPRESS
setprop log.tag.RtmEmbmsUtil SUPPRESS
setprop log.tag.RtmIms SUPPRESS
setprop log.tag.RtmImsConference SUPPRESS
setprop log.tag.RtmImsConfigController SUPPRESS
setprop log.tag.RtmImsDialog SUPPRESS
setprop log.tag.RtmModeCont SUPPRESS
setprop log.tag.RtmMwi SUPPRESS
setprop log.tag.RtmNwCtrl SUPPRESS
setprop log.tag.RtmPhb SUPPRESS
setprop log.tag.RtmRadioConfig SUPPRESS
setprop log.tag.RtmRadioCont SUPPRESS
setprop log.tag.RtmWp SUPPRESS
setprop log.tag.SIMRecords SUPPRESS
setprop log.tag.SQLiteQueryBuilder SUPPRESS
setprop log.tag.SensorManager SUPPRESS
setprop log.tag.ServiceManager SUPPRESS
setprop log.tag.SimSwitchOP01 SUPPRESS
setprop log.tag.SimSwitchOP02 SUPPRESS
setprop log.tag.SimSwitchOP18 SUPPRESS
setprop log.tag.SlotQueueEntry SUPPRESS
setprop log.tag.SpnOverride SUPPRESS
setprop log.tag.StatusBarManagerService SUPPRESS
setprop log.tag.StorageManager SUPPRESS
setprop log.tag.SurfaceFlinger SUPPRESS
setprop log.tag.SystemServer SUPPRESS
setprop log.tag.Telecom SUPPRESS
setprop log.tag.TelephonyManager SUPPRESS
setprop log.tag.TelephonyRegistry SUPPRESS
setprop log.tag.ThermalManager SUPPRESS
setprop log.tag.ToneGenerator SUPPRESS
setprop log.tag.UiccCard SUPPRESS
setprop log.tag.UiccController SUPPRESS
setprop log.tag.UsbHostManager SUPPRESS
setprop log.tag.UsbManager SUPPRESS
setprop log.tag.UxUtility SUPPRESS
setprop log.tag.VT SUPPRESS
setprop log.tag.VibratorService SUPPRESS
setprop log.tag.VpnManager SUPPRESS
setprop log.tag.VsimAdaptor SUPPRESS
setprop log.tag.WORLDMODE SUPPRESS
setprop log.tag.WallpaperManager SUPPRESS
setprop log.tag.WfoApp SUPPRESS
setprop log.tag.WifiManager SUPPRESS
setprop log.tag.WindowManager SUPPRESS
setprop log.tag.WindowManagerService SUPPRESS
setprop log.tag.WpfaCcciDataHeaderEncoder SUPPRESS
setprop log.tag.WpfaCcciReader SUPPRESS
setprop log.tag.WpfaCcciSender SUPPRESS
setprop log.tag.WpfaControlMsgHandler SUPPRESS
setprop log.tag.WpfaDriver SUPPRESS
setprop log.tag.WpfaDriverAccept SUPPRESS
setprop log.tag.WpfaDriverAdapter SUPPRESS
setprop log.tag.WpfaDriverDeReg SUPPRESS
setprop log.tag.WpfaDriverMessage SUPPRESS
setprop log.tag.WpfaDriverRegFilter SUPPRESS
setprop log.tag.WpfaDriverULIpPkt SUPPRESS
setprop log.tag.WpfaDriverUtilis SUPPRESS
setprop log.tag.WpfaDriverVersion SUPPRESS
setprop log.tag.WpfaFilterRuleReqHandler SUPPRESS
setprop log.tag.WpfaParsing SUPPRESS
setprop log.tag.WpfaRingBuffer SUPPRESS
setprop log.tag.WpfaRuleContainer SUPPRESS
setprop log.tag.WpfaRuleRegister SUPPRESS
setprop log.tag.WpfaShmAccessController SUPPRESS
setprop log.tag.WpfaShmReadMsgHandler SUPPRESS
setprop log.tag.WpfaShmSynchronizer SUPPRESS
setprop log.tag.WpfaShmWriteMsgHandler SUPPRESS
setprop log.tag.brevent.event SUPPRESS
setprop log.tag.libPowerHal SUPPRESS
setprop log.tag.libfuse SUPPRESS
setprop log.tag.mipc_lib SUPPRESS
setprop log.tag.mtkpower@impl SUPPRESS
setprop log.tag.mtkpower_client SUPPRESS
setprop log.tag.trm_lib SUPPRESS
setprop log.tag.wpfa_iptable_android SUPPRESS
setprop log.tag.Networklogger SUPPRESS
setprop log.tag.AudioFlinger::DeviceEffectProxy SUPPRESS
}
log > /dev/null 2>&1  
app() {
pm disable-user --user 0 com.xiaomi.joyose
pm disable-user --user 0 com.samsung.android.game.gos
pm disable-user --user 0 com.samsung.android.game.gametools
pm disable-user --user 0 com.samsung.android.game.gamehome
}
app > /dev/null 2>&1  
pe() {
setprop debug.sf.enable_adpf_cpu_hint true
setprop debug.rs.precision rs_fp_full
setprop debug.perf_event_max_sample_rate 1
setprop debug.perf_event_mlock_kb 2
setprop debug.perf_cpu_time_max_percent 1
setprop security.perf_harden 1
setprop security.perf_harden 0
setprop debug.lldb-rpc-server 0
setprop debug.MB.running 0
setprop debug.hwc.otf 0
setprop debug.art.monitor.app false
setprop debug.hwui.fps_divisor 1
setprop debug.sf.no_vsync 1 
setprop debug.sf.vsync 1
setprop debug.sf.hw 1
setprop debug.hwui.renderer skiagl
setprop debug.gpu.renderer skiagl
setprop debug.renderengine.backend skiaglthreaded
setprop debug.angle.overlay FPS:Skiagl*PipelineCache*
setprop debug.composition.7x27A.type gpu
setprop debug.composition.7x25A.type gpu
setprop debug.sf.hw 1
setprop debug.als.logs 0
setprop debug.atrace.tags.enableflags 0
setprop debug.egl.profiler 0
setprop debug.enable.wl_log 0
setprop debug.sf.enable_hwc_vds 0
setprop debug.sf.ddms 0
setprop debug.sf.dump 0
setprop debug.hwui.skia_atrace_enabled 0
setprop debug.app.performance_restricted false
setprop debug.mdpcomp.logs 0
setprop debug.egl.force_msaa 0
setprop debug.hwui.force_fxaa 0 
setprop debug.hwui.force_smaa 0 
setprop debug.hwui.force_msaa 0 
setprop debug.hwui.force_txaa 0 
setprop debug.hwui.force_csaa 0 
setprop debug.hwui.force_dlss 0 
setprop hw3d.force 1
setprop debug.hwc.otf 0
setprop debug.hwc_dump_en 0
setprop debug.egl.hw 1 
setprop debug.mdlogger.Running 0
setprop debug.egl.force_dmsaa 0
setprop debug.sf.showupdates 0
setprop debug.sf.showfps 0
setprop debug.sf.showcpu 0
setprop debug.hwui.overdraw false
setprop debug.overlayui.enable 0
setprop debug.hwui.use_hint_manager 1
setprop debug.sf.showbackground 0
setprop debug.sf.shoupdates 0
setprop debug.composition.type c2d
setprop debug.composition.type gpu
setprop debug.egl.swapinterval 0
setprop debug.cpuprio 7
setprop debug.gpuprio 7
setprop debug.ioprio 7
setprop debug.hwui.fps_divisor 1
setprop debug.javafx.animation.fullspeed true
setprop debug.systemuicompilerfilter speed-profile
setprop debug.cpurend.vsync false
setprop debug.gpurend.vsync false
setprop debug.performance.tuning 1
setprop debug.perf.tuning 1
setprop debug.hwui.use_layer_renderer true
setprop debug.hwui.target_cpu_time_percent 200
setprop debug.hwui.target_gpu_time_percent 200
setprop hwui.render_dirty_regions 0
setprop sys.hwc.gpu_perf_mode 1
setprop sem_enhanced_cpu_responsiveness 1
# From set_prop array
setprop debug.sf.hw 1
setprop debug.egl.hw 1
setprop debug.perf.tuning 1
setprop debug.performance.tuning 1
# From vsync array
setprop debug.egl.swapinterval 0
setprop debug.gr.swapinterval 0
setprop debug.sf.swapinterval 0
# From glob array
settings put global force_gpu_rendering 1
settings put global GPUTUNER_SWITCH true
settings put global CPUTUNER_SWITCH true
settings put global DYNAMIC_PERFORMANCE_DEFAULT_STATUS 1
settings put global DYNAMIC_PERFORMANCE_STATUS 1
settings put global low_power 0
settings put global miui_cpu_model 2
settings put global cached_apps_freezer enable
settings put global game_driver_optimize_fps 1
settings put global game_driver true
cmd device_config put gpufreq boost 1
cmd device_config put cpufreq boost 1
settings put system cpu_boost 1
settings put system gpu_boost 1    
setprop debug.dexopt.bg-dexopt speed-profile
setprop debug.dexopt.boot-after-ota verify
setprop debug.dexopt.install speed-profile
setprop debug.dexopt.bg-dexopt speed-profile
setprop debug.dexopt.boot-after-ota verify
setprop debug.dexopt.cmdline verify
setprop debug.dexopt.First-use speed-profile
setprop debug.dexoptinactive verify
setprop debug.dexoptinstall speed-profile
setprop debug.dexoptinstall-bulk speed-profile
setprop debug.dexoptinstall-bulk-downgraded verify
setprop debug.dexopt.install-bulk-secondary verify
setprop debug.dexopt.install-bulk-secondary-downgraded extract
setprop debug.dexoptinstall-Fast skip
setprop debug.dexopt.post-boot extract
# From cmd array (from previous input)
cmd power set-adaptive-power-saver-enabled false
cmd power set-fixed-performance-mode-enabled true
cmd power set-mode 0
am clear-debug-app all
am clear-exit-info all
am clear-watch-heap all
am set-deterministic-uid-idle all false
sm idle-maint abort
am kill-all
}
pe > /dev/null 2>&1  
game() {
# From secure array
settings put secure long_press_timeout 500
settings put secure multi_press_timeout 500
settings put secure game_auto_temperature 0
settings put secure game_dashboard_always_on 1
settings put secure high_priority 1
device_config put game_overlay com.dts.freefireth mode=2,angle=true,fps=$refresh_rate,loadingBoost=999999999
device_config put game_overlay com.dts.freefiremax mode=2,angle=true,fps=$refresh_rate,loadingBoost=999999999
settings put system touch.response_time 5
settings put system touch_distance_scale 1
settings put system touch_sensitivity 1
settings put system touch.precision 1
settings put system tap_delay 0
settings put global touchresponse_time_boost 1
settings put global low_latency_inputenabled 1
settings put system pointer_speed 7
settings put system gesture_sensitivity 2
settings put system scroll.smoothness 1
settings put secure double_tap_timeout 400
settings put secure multi_press_timeout 500
settings put secure long_press_timeout 500
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
settings put global touch_fling_velocity 25000
settings put global fling_velocity 25000   
settings put system screen_brightness_mode 0
settings put system touch_delay 0
settings put system haptic_feedback_enabled 0
device_config put touchscreen input_drag_min_switch_speed 150
device_config put systemui min_fling_velocity 25000
device_config put systemui max_fling_velocity 25000
device_config put input touch_screen_sample_interval_ms 2

for dcx in odp_enable_client_error_logging fcp_enable_client_error_logging odp_background_jobs_logging_enabled fcp_enable_background_jobs_logging; do
    value=$(device_config get on_device_personalization "$dcx")
    if [ "$value" != "null" ] && [ -n "$value" ]; then
        device_config put on_device_personalization "$dcx" false
    fi
done

for key in measurement_verbose_debug_reporting_job_required_network_type measurement_debug_reporting_fallback_job_required_network_type measurement_debug_reporting_job_required_network_type measurement_aggregate_fallback_reporting_job_required_network_type measurement_aggregate_reporting_job_required_network_type measurement_async_registration_fallback_job_required_network_type measurement_async_registration_queue_job_required_network_type measurement_event_fallback_reporting_job_required_network_type measurement_event_reporting_job_required_network_type; do
    value=$(device_config get adservices "$key")
    if [ "$value" != "null" ] && [ -n "$value" ]; then
        device_config put adservices "$key" 0
    fi
done

for key in adservice_system_service_enabled cobalt_logging_enabled enable_logged_topic adservice_error_logging_enabled measurement_enable_app_package_name_logging measurement_enable_source_debug_report fledge_app_package_name_logging fledge_auction_server_enable_debug_reporting fledge_auction_server_api_usage_metrics_enabled fledge_auction_server_enabled_for_report_event fledge_auction_server_enabled_for_report_impression fledge_auction_server_enabled_for_select_ads_mediation; do
    value=$(device_config get adservices "$key")
    if [ "$value" != "null" ] && [ -n "$value" ]; then
        device_config put adservices "$key" false
    fi
done
}
game > /dev/null 2>&1  
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
  device_config put game_overlay "$package" mode=2,angle=true,fps=$refresh_rate,loadingBoost=999999999true
  cmd package compile -m speed-profile -f "$package"
done
}
tro > /dev/null 2>&1  
ff() {
cmd game set --fps $refresh_rate --mode 2 --downscale 0.6 com.dts.freefiremax
cmd game set --fps $refresh_rate --mode 2 --downscale 0.6 com.dts.freefireth
}
ff > /dev/null 2>&1  
# Kết quả
echo "$DIVIDER"
echo "✔$(pad_text "OPTIMIZATION DONE")✔"
echo "$SECTION_DIV"
echo "$PROGRESS_DIV Performance Boosted!      $COMPLETION_MARK"
echo "$PROGRESS_DIV Lag Reduced!              $COMPLETION_MARK"
echo "$PROGRESS_DIV Follow: GRAP FIFA (YT)    $COMPLETION_MARK"
echo "$DIVIDER"
# Gửi thông báo
cmd notification post -t "🚀PerGRV1 Optimizer🚀" -S inbox \
    --line "Performance Boosted!" \
    --line "YouTube: GRAP FIFA" \
    myTag "Game Booster" >/dev/null
