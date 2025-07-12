#!/system/bin/sh
DIVIDER="─────────────◇─────────────────────◇─────────────"
SECTION_DIV="────────────────────────★────────────────────────"
PROGRESS_DIV="──────➤ "
STICKER_HEADER="🔥"
STICKER_PROGRESS="✅ "
STICKER_ERROR="⚠️ "
STICKER_COMPLETION="🚀 "

pad_text() {
    local text="$1"
    local width=45
    local len=${#text}
    local padding=$(( (width - len) / 2 ))
    local left_pad=""
    local right_pad=""
    local i=0
    while [ $i -lt $padding ]; do
        left_pad="$left_pad "
        right_pad="$right_pad "
        i=$((i + 1))
    done
    echo "$left_pad$text$right_pad"
}


echo "$DIVIDER"
echo "$STICKER_HEADER$(pad_text "UltraV3 Optimizer")$STICKER_HEADER"
echo "$SECTION_DIV"
echo " $(pad_text "Increase performance and optimize the game best")"
echo "$DIVIDER"
echo "   Developed by : GRAP FIFA"
echo "   YouTube      : GRAP FIFA | TikTok: GRAP FIFA"
echo "   Zalo         : Thang Le"
if [ "$(id -u)" -eq 0 ] || which su >/dev/null 2>&1; then
    echo "   Device       : Root"
    root_status="root"
else
    echo "   Device       : No Root"
    root_status="not_root"
fi
echo "   Module       : UltraV3 VIP"
echo "   Version      : V3"
echo "   Price        : 100k"
echo "   Powered by   : GRAP FIFA AKZ TEAM"
echo "$DIVIDER"
echo ""
echo "$SECTION_DIV"
echo "$STICKER_HEADER$(pad_text "Initializing System Analysis")$STICKER_HEADER"
echo "$SECTION_DIV"
echo ""

# Lấy thông tin thiết bị
kernel_version=$(uname -r)
device_name=$(getprop ro.product.model)
manufacturer=$(getprop ro.product.manufacturer)
adr_version=$(getprop ro.build.version.sdk)
adr_build=$(getprop ro.build.version.incremental)
product_locale=$(getprop ro.product.locale)
total_ram=$(grep MemTotal /proc/meminfo | awk '{printf "%.0f MB", $2 / 1024}')
cpu_abi=$(getprop ro.product.cpu.abi)
cpu_abi2=$(getprop ro.product.cpu.abi2)
bit=$(if echo "$cpu_abi" | grep -iq "64" || echo "$cpu_abi2" | grep -iq "64"; then echo "64-bit"; else echo "32-bit"; fi)
check_chip=$(getprop ro.soc.manufacturer)
vulkan=$(getprop ro.hardware.vulkan)

# Thông tin GPU
gpu_info=$(printf "%s\n%s" "$(getprop ro.hardware.egl)" "$(getprop ro.board.platform)" | sed '/^$/d')

# Hiển thị thông tin
echo "$DIVIDER"
echo "$STICKER_HEADER$(pad_text "DEVICE SPECIFICATIONS")$STICKER_HEADER"
echo "$SECTION_DIV"
echo "   Device Model      : ${device_name}" | cut -c 1-79
sleep 0.5
echo "   Manufacturer      : ${manufacturer}" | cut -c 1-79
sleep 0.5
echo "   Android SDK       : ${adr_version}" | cut -c 1-79
echo "   Build ID          : ${adr_build}" | cut -c 1-79
echo "   System Locale     : ${product_locale}" | cut -c 1-79
echo "   Kernel Version    : ${kernel_version}" | cut -c 1-79
echo "   Total RAM         : ${total_ram}" | cut -c 1-79
echo "   CPU Architecture  : ${cpu_abi}" | cut -c 1-79
echo "   GPU Information   : ${gpu_info}" | cut -c 1-79
echo "   Chipset           : ${check_chip}" | cut -c 1-79
echo "   Vulkan Support    : ${vulkan}" | cut -c 1-79
sleep 0.5
echo "   System Arch       : ${bit}" | cut -c 1-79
echo "$DIVIDER"
echo ""
sleep 1

echo "$SECTION_DIV"
echo "$STICKER_HEADER$(pad_text "PERFORMANCE OPTIMIZATION INITIATED")$STICKER_HEADER"
echo "$SECTION_DIV"
echo "$PROGRESS_DIV[1/5] Retrieving System Data...       ${STICKER_PROGRESS}"
echo "$PROGRESS_DIV[2/5] Accessing System Files...       ${STICKER_PROGRESS}"
echo "$PROGRESS_DIV[3/5] Activating Turbo Mode...        ${STICKER_PROGRESS}"
echo ""
echo ""
sleep 0.5
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
echo "$PROGRESS_DIV [4/5] Applied Display Optimization for ${refresh_rate}Hz ${STICKER_PROGRESS}"
#Tối ưu ram
get_ram_gb() {
    mem_kb=$(grep -i MemTotal /proc/meminfo | awk '{print $2}')
    mem_gb=$(( (mem_kb + 1048575) / 1048576 )) # Làm tròn lên GB
    echo "$mem_gb"
}

apply_config() {
    ram_gb=$1
    echo "$PROGRESS_DIV Detected RAM: ${ram_gb}GB"

    if [ "$ram_gb" -le 2 ]; then
        echo "$PROGRESS_DIV Applying Config for Low RAM (≤2GB)"
        settings put global activity_manager_constants max_cached_processes=48,CUR_MAX_CACHED_PROCESSES=96,CUR_MAX_EMPTY_PROCESSES=32,CUR_TRIM_EMPTY_PROCESSES=24,CUR_TRIM_CACHED_PROCESSES=32,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=2,MULTI_THREAD_CPU=false,power_check_max_cpu_1=90,power_check_max_cpu_2=80,power_check_max_cpu_3=60,power_check_max_cpu_4=50,power_check_max_gpu=85,max_empty_time_millis=180000,max_phantom_processes=4,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 4096
        setprop debug.hwui.layer_cache_size 4096
        setprop debug.hwui.pipeline_cache_size 4096
        setprop debug.hwui.fbo_cache_size 3072
        setprop debug.hwui.cache_size 4096

    elif [ "$ram_gb" -le 3 ]; then
        echo "$PROGRESS_DIV Applying Config for 3GB RAM"
        settings put global activity_manager_constants max_cached_processes=64,CUR_MAX_CACHED_PROCESSES=128,CUR_MAX_EMPTY_PROCESSES=48,CUR_TRIM_EMPTY_PROCESSES=32,CUR_TRIM_CACHED_PROCESSES=48,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=2,MULTI_THREAD_CPU=true,power_check_max_cpu_1=92,power_check_max_cpu_2=85,power_check_max_cpu_3=65,power_check_max_cpu_4=55,power_check_max_gpu=87,max_empty_time_millis=180000,max_phantom_processes=5,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 6144
        setprop debug.hwui.layer_cache_size 6144
        setprop debug.hwui.pipeline_cache_size 6144
        setprop debug.hwui.fbo_cache_size 4096
        setprop debug.hwui.cache_size 5120

    elif [ "$ram_gb" -le 4 ]; then
        echo "$PROGRESS_DIV Applying Config for 4GB RAM"
        settings put global activity_manager_constants max_cached_processes=96,CUR_MAX_CACHED_PROCESSES=256,CUR_MAX_EMPTY_PROCESSES=64,CUR_TRIM_EMPTY_PROCESSES=48,CUR_TRIM_CACHED_PROCESSES=64,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=6,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 8192
        setprop debug.hwui.layer_cache_size 8192
        setprop debug.hwui.pipeline_cache_size 8192
        setprop debug.hwui.fbo_cache_size 6144
        setprop debug.hwui.cache_size 7168

    elif [ "$ram_gb" -le 6 ]; then
        echo "$PROGRESS_DIV Applying Config for 6GB RAM"
        settings put global activity_manager_constants max_cached_processes=128,CUR_MAX_CACHED_PROCESSES=320,CUR_MAX_EMPTY_PROCESSES=96,CUR_TRIM_EMPTY_PROCESSES=64,CUR_TRIM_CACHED_PROCESSES=96,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=8,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 10240
        setprop debug.hwui.layer_cache_size 10240
        setprop debug.hwui.pipeline_cache_size 10240
        setprop debug.hwui.fbo_cache_size 8192
        setprop debug.hwui.cache_size 9216

    elif [ "$ram_gb" -le 8 ]; then
        echo "$PROGRESS_DIV Applying Config for 8GB RAM"
        settings put global activity_manager_constants max_cached_processes=160,CUR_MAX_CACHED_PROCESSES=384,CUR_MAX_EMPTY_PROCESSES=128,CUR_TRIM_EMPTY_PROCESSES=96,CUR_TRIM_CACHED_PROCESSES=128,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=3,MULTI_THREAD_CPU=true,power_check_max_cpu_1=95,power_check_max_cpu_2=90,power_check_max_cpu_3=70,power_check_max_cpu_4=60,power_check_max_gpu=90,max_empty_time_millis=180000,max_phantom_processes=10,service_timeout=15000,bg_start_timeout=10000,gc_timeout=8000,content_provider_retain_time=5000

        setprop debug.hwui.texture_cache_size 12288
        setprop debug.hwui.layer_cache_size 12288
        setprop debug.hwui.pipeline_cache_size 12288
        setprop debug.hwui.fbo_cache_size 10240
        setprop debug.hwui.cache_size 11264
    elif [ "$ram_gb" -le 12 ]; then
        echo "$PROGRESS_DIV Applying Config for 12GB RAM"
        settings put global activity_manager_constants max_cached_processes=224,CUR_MAX_CACHED_PROCESSES=512,CUR_MAX_EMPTY_PROCESSES=160,CUR_TRIM_EMPTY_PROCESSES=128,CUR_TRIM_CACHED_PROCESSES=160,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=4,MULTI_THREAD_CPU=true,power_check_max_cpu_1=97,power_check_max_cpu_2=94,power_check_max_cpu_3=78,power_check_max_cpu_4=68,power_check_max_gpu=93,max_empty_time_millis=150000,max_phantom_processes=14,service_timeout=10000,bg_start_timeout=7000,gc_timeout=5000,content_provider_retain_time=3000

        setprop debug.hwui.texture_cache_size 16384
        setprop debug.hwui.layer_cache_size 16384
        setprop debug.hwui.pipeline_cache_size 16384
        setprop debug.hwui.fbo_cache_size 14336
        setprop debug.hwui.cache_size 15360

    elif [ "$ram_gb" -le 16 ]; then
        echo "$PROGRESS_DIV Applying Config for 16GB RAM"
        settings put global activity_manager_constants max_cached_processes=256,CUR_MAX_CACHED_PROCESSES=576,CUR_MAX_EMPTY_PROCESSES=192,CUR_TRIM_EMPTY_PROCESSES=160,CUR_TRIM_CACHED_PROCESSES=192,MEM_CONSTANTS_SUPER_SIZE=true,cpu_usage_scaling_factor=4,MULTI_THREAD_CPU=true,power_check_max_cpu_1=98,power_check_max_cpu_2=95,power_check_max_cpu_3=80,power_check_max_cpu_4=70,power_check_max_gpu=94,max_empty_time_millis=150000,max_phantom_processes=16,service_timeout=9000,bg_start_timeout=6000,gc_timeout=5000,content_provider_retain_time=3000

        setprop debug.hwui.texture_cache_size 20480
        setprop debug.hwui.layer_cache_size 20480
        setprop debug.hwui.pipeline_cache_size 20480
        setprop debug.hwui.fbo_cache_size 16384
        setprop debug.hwui.cache_size 18432

    elif [ "$ram_gb" -ge 17 ]; then
        echo "$PROGRESS_DIV Applying Config for High-End RAM (≥17GB)"
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
    echo "$PROGRESS_DIV [5/5] RAM Optimization Completed ${STICKER_PROGRESS}"
}

main() {
    ram=$(get_ram_gb)
    apply_config "$ram"
}

main
# Suppress log tags
log() {
setprop log.tag.FA WARN
setprop log.tag.AF::MmapTrack WARN
setprop log.tag.AF::OutputTrack WARN
setprop log.tag.AF::PatchRecord WARN
setprop log.tag.AF::PatchTrack WARN
setprop log.tag.AF::RecordHandle WARN
setprop log.tag.AF::RecordTrack WARN
setprop log.tag.AF::Track WARN
setprop log.tag.AF::TrackBase WARN
setprop log.tag.AF::TrackHandle WARN
setprop log.tag.APM-KpiMonitor WARN
setprop log.tag.APM-ServiceJ WARN
setprop log.tag.APM-SessionJ WARN
setprop log.tag.APM-SessionN WARN
setprop log.tag.APM-Subscriber WARN
setprop log.tag.APM::AudioCollections WARN
setprop log.tag.APM::AudioInputDescriptor WARN
setprop log.tag.APM::AudioOutputDescriptor WARN
setprop log.tag.APM::AudioPatch WARN
setprop log.tag.APM::AudioPolicyEngine WARN
setprop log.tag.APM::AudioPolicyEngine::Base WARN
setprop log.tag.APM::AudioPolicyEngine::Config WARN
setprop log.tag.APM::AudioPolicyEngine::ProductStrategy WARN
setprop log.tag.APM::AudioPolicyEngine::VolumeGroup WARN
setprop log.tag.APM::Devices WARN
setprop log.tag.APM::IOProfile WARN
setprop log.tag.APM::Serializer WARN
setprop log.tag.APM::VolumeCurve WARN
setprop log.tag.APM_AudioPolicyManager WARN
setprop log.tag.APM_ClientDescriptor WARN
setprop log.tag.AT WARN
setprop log.tag.AccountManager WARN
setprop log.tag.ActivityManager WARN
setprop log.tag.ActivityManagerService WARN
setprop log.tag.ActivityTaskManager WARN
setprop log.tag.ActivityTaskManagerService WARN
setprop log.tag.AdnRecord WARN
setprop log.tag.AdnRecordCache WARN
setprop log.tag.AdnRecordLoader WARN
setprop log.tag.AirplaneHandler WARN
setprop log.tag.AlarmManager WARN
setprop log.tag.AlarmManagerService WARN
setprop log.tag.AndroidRuntime WARN
setprop log.tag.AppOps WARN
setprop log.tag.AudioAttributes WARN
setprop log.tag.AudioEffect WARN
setprop log.tag.AudioFlinger WARN
setprop log.tag.AudioFlinger::DeviceEffectProxy WARN
setprop log.tag.AudioFlinger::DeviceEffectProxy::ProxyCallback WARN
setprop log.tag.AudioFlinger::EffectBase WARN
setprop log.tag.AudioFlinger::EffectChain WARN
setprop log.tag.AudioFlinger::EffectHandle WARN
setprop log.tag.AudioFlinger::EffectModule WARN
setprop log.tag.AudioFlinger_Threads WARN
setprop log.tag.AudioHwDevice WARN
setprop log.tag.AudioManager WARN
setprop log.tag.AudioPolicy WARN
setprop log.tag.AudioPolicyEffects WARN
setprop log.tag.AudioPolicyIntefaceImpl WARN
setprop log.tag.AudioPolicyManager WARN
setprop log.tag.AudioPolicyService WARN
setprop log.tag.AudioProductStrategy WARN
setprop log.tag.AudioRecord WARN
setprop log.tag.AudioService WARN
setprop log.tag.AudioSystem WARN
setprop log.tag.AudioTrack WARN
setprop log.tag.AudioTrackShared WARN
setprop log.tag.AudioVolumeGroup WARN
setprop log.tag.BackupManager WARN
setprop log.tag.BatteryManager WARN
setprop log.tag.BatteryStatsService WARN
setprop log.tag.BluetoothAdapter WARN
setprop log.tag.BluetoothDevice WARN
setprop log.tag.BluetoothGattService WARN
setprop log.tag.BluetoothHidService WARN
setprop log.tag.BluetoothManager WARN
setprop log.tag.BluetoothMapService WARN
setprop log.tag.BluetoothPanService WARN
setprop log.tag.BluetoothPbapService WARN
setprop log.tag.BluetoothSapService WARN
setprop log.tag.BluetoothService WARN
setprop log.tag.BluetoothSocket WARN
setprop log.tag.BufferQueueDump WARN
setprop log.tag.BufferQueueProducer WARN
setprop log.tag.C2K_AT WARN
setprop log.tag.C2K_ATConfig WARN
setprop log.tag.C2K_RILC WARN
setprop log.tag.CAM2PORT_ WARN
setprop log.tag.CapaSwitch WARN
setprop log.tag.CarrierExpressServiceImpl WARN
setprop log.tag.CarrierExpressServiceImplExt WARN
setprop log.tag.ClipboardManager WARN
setprop log.tag.ConnectivityManager WARN
setprop log.tag.ConnectivityService WARN
setprop log.tag.ConsumerIrService WARN
setprop log.tag.ContentManager WARN
setprop log.tag.CountryDetector WARN
setprop log.tag.DMC-ApmService WARN
setprop log.tag.DMC-Core WARN
setprop log.tag.DMC-DmcService WARN
setprop log.tag.DMC-EventsSubscriber WARN
setprop log.tag.DMC-ReqQManager WARN
setprop log.tag.DMC-SessionManager WARN
setprop log.tag.DMC-TranslatorLoader WARN
setprop log.tag.DMC-TranslatorUtils WARN
setprop log.tag.DSSelector WARN
setprop log.tag.DSSelectorOP01 WARN
setprop log.tag.DSSelectorOP02 WARN
setprop log.tag.DSSelectorOP09 WARN
setprop log.tag.DSSelectorOP18 WARN
setprop log.tag.DSSelectorOm WARN
setprop log.tag.DSSelectorUtil WARN
setprop log.tag.DataDispatcher WARN
setprop log.tag.DeviceIdleController WARN
setprop log.tag.DevicePolicyManager WARN
setprop log.tag.DevicePolicyManagerService WARN
setprop log.tag.DisplayManager WARN
setprop log.tag.DisplayManagerService WARN
setprop log.tag.DockObserver WARN
setprop log.tag.DownloadManager WARN
setprop log.tag.ExternalSimMgr WARN
setprop log.tag.FastCapture WARN
setprop log.tag.FastMixer WARN
setprop log.tag.FastMixerState WARN
setprop log.tag.FastThread WARN
setprop log.tag.FragmentManager WARN
setprop log.tag.FuseDaemon WARN
setprop log.tag.GAv4 WARN
setprop log.tag.GraphicsStats WARN
setprop log.tag.GsmCallTkrHlpr WARN
setprop log.tag.GsmCdmaConn WARN
setprop log.tag.GsmCdmaPhone WARN
setprop log.tag.HardwarePropertiesManager WARN
setprop log.tag.HardwareService WARN
setprop log.tag.IAudioFlinger WARN
setprop log.tag.IMSRILRequest WARN
setprop log.tag.IMS_RILA WARN
setprop log.tag.IccCardProxy WARN
setprop log.tag.IccPhoneBookIM WARN
setprop log.tag.IccProvider WARN
setprop log.tag.ImsApp WARN
setprop log.tag.ImsBaseCommands WARN
setprop log.tag.ImsCall WARN
setprop log.tag.ImsCallProfile WARN
setprop log.tag.ImsCallSession WARN
setprop log.tag.ImsEcbm WARN
setprop log.tag.ImsEcbmProxy WARN
setprop log.tag.ImsManager WARN
setprop log.tag.ImsPhone WARN
setprop log.tag.ImsPhoneBase WARN
setprop log.tag.ImsPhoneCall WARN
setprop log.tag.ImsService WARN
setprop log.tag.ImsVTProvider WARN
setprop log.tag.InputDispatcher WARN
setprop log.tag.InputManager WARN
setprop log.tag.InputManagerService WARN
setprop log.tag.InputMethodManager WARN
setprop log.tag.InputMethodManagerService WARN
setprop log.tag.InterfaceManager WARN
setprop log.tag.IsimFileHandler WARN
setprop log.tag.IsimRecords WARN
setprop log.tag.JobScheduler WARN
setprop log.tag.KeyguardManager WARN
setprop log.tag.LCM-Subscriber WARN
setprop log.tag.LIBC2K_RIL WARN
setprop log.tag.LocationManager WARN
setprop log.tag.LocationManagerService WARN
setprop log.tag.LocationProvider WARN
setprop log.tag.MAPI-CommandProcessor WARN
setprop log.tag.MAPI-MdiRedirector WARN
setprop log.tag.MAPI-MdiRedirectorCtrl WARN
setprop log.tag.MAPI-NetworkSocketConnection WARN
setprop log.tag.MAPI-SocketConnection WARN
setprop log.tag.MAPI-SocketListener WARN
setprop log.tag.MAPI-TranslatorManager WARN
setprop log.tag.MDM-Subscriber WARN
setprop log.tag.MTKSST WARN
setprop log.tag.MTK_APPList WARN
setprop log.tag.MediaPlayer WARN
setprop log.tag.MediaPlayerService WARN
setprop log.tag.MediaRouter WARN
setprop log.tag.MediaSession WARN
setprop log.tag.MipcEventHandler WARN
setprop log.tag.MountService WARN
setprop log.tag.MtkAdnRecord WARN
setprop log.tag.MtkCsimFH WARN
setprop log.tag.MtkEmbmsAdaptor WARN
setprop log.tag.MtkFactory WARN
setprop log.tag.MtkGsmCdmaConn WARN
setprop log.tag.MtkIccCardProxy WARN
setprop log.tag.MtkIccPHBIM WARN
setprop log.tag.MtkIccProvider WARN
setprop log.tag.MtkIccSmsInterfaceManager WARN
setprop log.tag.MtkImsManager WARN
setprop log.tag.MtkImsService WARN
setprop log.tag.MtkIsimFH WARN
setprop log.tag.MtkPhoneNotifr WARN
setprop log.tag.MtkPhoneNumberUtils WARN
setprop log.tag.MtkPhoneSwitcher WARN
setprop log.tag.MtkRecordLoader WARN
setprop log.tag.MtkRuimFH WARN
setprop log.tag.MtkSIMFH WARN
setprop log.tag.MtkSIMRecords WARN
setprop log.tag.MtkSmsCbHeader WARN
setprop log.tag.MtkSmsManager WARN
setprop log.tag.MtkSmsMessage WARN
setprop log.tag.MtkSpnOverride WARN
setprop log.tag.MtkSubCtrl WARN
setprop log.tag.MtkTelephonyManagerEx WARN
setprop log.tag.MtkUiccCard WARN
setprop log.tag.MtkUiccCardApp WARN
setprop log.tag.MtkUiccCtrl WARN
setprop log.tag.MtkUsimFH WARN
setprop log.tag.MtkUsimPhoneBookManager WARN
setprop log.tag.MwiRIL WARN
setprop log.tag.NetAgentService WARN
setprop log.tag.NetAgent_IO WARN
setprop log.tag.NetLnkEventHdlr WARN
setprop log.tag.NetworkManagement WARN
setprop log.tag.NetworkManagementService WARN
setprop log.tag.NetworkPolicy WARN
setprop log.tag.NetworkPolicyManagerService WARN
setprop log.tag.NetworkStats WARN
setprop log.tag.NetworkTimeUpdateService WARN
setprop log.tag.NotificationManager WARN
setprop log.tag.NotificationManagerService WARN
setprop log.tag.OperatorUtils WARN
setprop log.tag.PKM-Lib WARN
setprop log.tag.PKM-MDM WARN
setprop log.tag.PKM-Monitor WARN
setprop log.tag.PKM-SA WARN
setprop log.tag.PKM-Service WARN
setprop log.tag.PQ_DS WARN
setprop log.tag.PackageInstaller WARN
setprop log.tag.PackageManager WARN
setprop log.tag.PersistentDataBlockManager WARN
setprop log.tag.Phone WARN
setprop log.tag.PhoneConfigurationSettings WARN
setprop log.tag.PhoneFactory WARN
setprop log.tag.PowerHalAddressUitls WARN
setprop log.tag.PowerHalMgrImpl WARN
setprop log.tag.PowerHalMgrServiceImpl WARN
setprop log.tag.PowerHalWifiMonitor WARN
setprop log.tag.PowerManager WARN
setprop log.tag.PowerManagerService WARN
setprop log.tag.PrintManager WARN
setprop log.tag.ProcessStats WARN
setprop log.tag.ProxyController WARN
setprop log.tag.RFX WARN
setprop log.tag.RIL WARN
setprop log.tag.RIL-Fusion WARN
setprop log.tag.RIL-Netlink WARN
setprop log.tag.RIL-Parcel WARN
setprop log.tag.RIL-SocListen WARN
setprop log.tag.RIL-Socket WARN
setprop log.tag.RILC WARN
setprop log.tag.RILC-OP WARN
setprop log.tag.RILD WARN
setprop log.tag.RILMD2-SS WARN
setprop log.tag.RIL_UIM_SOCKET WARN
setprop log.tag.RadioManager WARN
setprop log.tag.RfxAction WARN
setprop log.tag.RfxBaseHandler WARN
setprop log.tag.RfxChannelMgr WARN
setprop log.tag.RfxCloneMgr WARN
setprop log.tag.RfxContFactory WARN
setprop log.tag.RfxController WARN
setprop log.tag.RfxDebugInfo WARN
setprop log.tag.RfxDisThread WARN
setprop log.tag.RfxFragEnc WARN
setprop log.tag.RfxHandlerMgr WARN
setprop log.tag.RfxIdToMsgId WARN
setprop log.tag.RfxIdToStr WARN
setprop log.tag.RfxMainThread WARN
setprop log.tag.RfxMclDisThread WARN
setprop log.tag.RfxMclMessenger WARN
setprop log.tag.RfxMclStatusMgr WARN
setprop log.tag.RfxMessage WARN
setprop log.tag.RfxObject WARN
setprop log.tag.RfxOpUtils WARN
setprop log.tag.RfxRilAdapter WARN
setprop log.tag.RfxRilUtils WARN
setprop log.tag.RfxRoot WARN
setprop log.tag.RfxStatusMgr WARN
setprop log.tag.RfxTimer WARN
setprop log.tag.RilClient WARN
setprop log.tag.RilOemClient WARN
setprop log.tag.RilOpProxy WARN
setprop log.tag.RmmCapa WARN
setprop log.tag.RmmCommSimOpReq WARN
setprop log.tag.RmmDcEvent WARN
setprop log.tag.RmmDcPdnManager WARN
setprop log.tag.RmmDcUrcHandler WARN
setprop log.tag.RmmDcUtility WARN
setprop log.tag.RmmEccNumberReqHdlr WARN
setprop log.tag.RmmEccNumberUrcHandler WARN
setprop log.tag.RmmEmbmsReq WARN
setprop log.tag.RmmEmbmsUrc WARN
setprop log.tag.RmmImsCtlReqHdl WARN
setprop log.tag.RmmImsCtlUrcHdl WARN
setprop log.tag.RmmMwi WARN
setprop log.tag.RmmNwAsyncHdlr WARN
setprop log.tag.RmmNwHdlr WARN
setprop log.tag.RmmNwNrtReqHdlr WARN
setprop log.tag.RmmNwRTReqHdlr WARN
setprop log.tag.RmmNwRatSwHdlr WARN
setprop log.tag.RmmNwReqHdlr WARN
setprop log.tag.RmmNwUrcHdlr WARN
setprop log.tag.RmmOemHandler WARN
setprop log.tag.RmmOpRadioReq WARN
setprop log.tag.RmmPhbReq WARN
setprop log.tag.RmmPhbUrc WARN
setprop log.tag.RmmRadioReq WARN
setprop log.tag.RmmSimBaseHandler WARN
setprop log.tag.RmmSimCommReq WARN
setprop log.tag.RmmSimCommUrc WARN
setprop log.tag.RmmWp WARN
setprop log.tag.RtmCapa WARN
setprop log.tag.RtmCommSimCtrl WARN
setprop log.tag.RtmDC WARN
setprop log.tag.RtmEccNumberController WARN
setprop log.tag.RtmEmbmsAt WARN
setprop log.tag.RtmEmbmsUtil WARN
setprop log.tag.RtmIms WARN
setprop log.tag.RtmImsConference WARN
setprop log.tag.RtmImsConfigController WARN
setprop log.tag.RtmImsDialog WARN
setprop log.tag.RtmModeCont WARN
setprop log.tag.RtmMwi WARN
setprop log.tag.RtmNwCtrl WARN
setprop log.tag.RtmPhb WARN
setprop log.tag.RtmRadioConfig WARN
setprop log.tag.RtmRadioCont WARN
setprop log.tag.RtmWp WARN
setprop log.tag.SIMRecords WARN
setprop log.tag.SQLiteQueryBuilder WARN
setprop log.tag.SensorManager WARN
setprop log.tag.ServiceManager WARN
setprop log.tag.SimSwitchOP01 WARN
setprop log.tag.SimSwitchOP02 WARN
setprop log.tag.SimSwitchOP18 WARN
setprop log.tag.SlotQueueEntry WARN
setprop log.tag.SpnOverride WARN
setprop log.tag.StatusBarManagerService WARN
setprop log.tag.StorageManager WARN
setprop log.tag.SurfaceFlinger WARN
setprop log.tag.SystemServer WARN
setprop log.tag.Telecom WARN
setprop log.tag.TelephonyManager WARN
setprop log.tag.TelephonyRegistry WARN
setprop log.tag.ThermalManager WARN
setprop log.tag.ToneGenerator WARN
setprop log.tag.UiccCard WARN
setprop log.tag.UiccController WARN
setprop log.tag.UsbHostManager WARN
setprop log.tag.UsbManager WARN
setprop log.tag.UxUtility WARN
setprop log.tag.VT WARN
setprop log.tag.VibratorService WARN
setprop log.tag.VpnManager WARN
setprop log.tag.VsimAdaptor WARN
setprop log.tag.WORLDMODE WARN
setprop log.tag.WallpaperManager WARN
setprop log.tag.WfoApp WARN
setprop log.tag.WifiManager WARN
setprop log.tag.WindowManager WARN
setprop log.tag.WindowManagerService WARN
setprop log.tag.WpfaCcciDataHeaderEncoder WARN
setprop log.tag.WpfaCcciReader WARN
setprop log.tag.WpfaCcciSender WARN
setprop log.tag.WpfaControlMsgHandler WARN
setprop log.tag.WpfaDriver WARN
setprop log.tag.WpfaDriverAccept WARN
setprop log.tag.WpfaDriverAdapter WARN
setprop log.tag.WpfaDriverDeReg WARN
setprop log.tag.WpfaDriverMessage WARN
setprop log.tag.WpfaDriverRegFilter WARN
setprop log.tag.WpfaDriverULIpPkt WARN
setprop log.tag.WpfaDriverUtilis WARN
setprop log.tag.WpfaDriverVersion WARN
setprop log.tag.WpfaFilterRuleReqHandler WARN
setprop log.tag.WpfaParsing WARN
setprop log.tag.WpfaRingBuffer WARN
setprop log.tag.WpfaRuleContainer WARN
setprop log.tag.WpfaRuleRegister WARN
setprop log.tag.WpfaShmAccessController WARN
setprop log.tag.WpfaShmReadMsgHandler WARN
setprop log.tag.WpfaShmSynchronizer WARN
setprop log.tag.WpfaShmWriteMsgHandler WARN
setprop log.tag.brevent.event WARN
setprop log.tag.libPowerHal WARN
setprop log.tag.libfuse WARN
setprop log.tag.mipc_lib WARN
setprop log.tag.mtkpower@impl WARN
setprop log.tag.mtkpower_client WARN
setprop log.tag.trm_lib WARN
setprop log.tag.wpfa_iptable_android WARN
setprop log.tag.Networklogger WARN
setprop log.tag.AudioFlinger::DeviceEffectProxy WARN
}
log > /dev/null 2>&1  
echo "$PROGRESS_DIV Log Suppression Applied ${STICKER_PROGRESS}"
# Performance props
pe() {
settings put system POWER_BALANCED_MODE_OPEN 0
settings put system POWER_PERFORMANCE_MODE_OPEN 1
settings put system POWER_SAVE_MODE_OPEN 0
settings put system POWER_SAVE_PRE_CLEAN_MEMORY_TIME 0
settings put system POWER_SAVE_PRE_HIDE_MODE performance
settings put system POWER_SAVE_PRE_SYNCHRONIZE_ENABLE 0
settings put global GPUTUNER_SWITCH true
settings put global CPUTUNER_SWITCH true
settings put global performance_profile high_performance
cmd power set-adaptive-power-saver-enabled false
cmd power set-fixed-performance-mode-enabled true
cmd power set-mode 0
setprop debug.javafx.animation.fullspeed true
setprop debug.javafx.animation.framerate 165
setprop debug.javafx.animation.fullframe 1
setprop debug.rs.use_fast_math 1
setprop debug.config.refresh_rate.boost true
setprop debug.sf.use_frame_rate_priority 1
setprop debug.sf.frame_rate_multiple_threshold 999
setprop debug.sf.frame_rate_multiple_fences 999
device_config put activity_manager fgs_start_allowed_log_sample_rate 0
device_config put activity_manager fgs_start_denied_log_sample_rate 0
}
pe > /dev/null 2>&1  
echo "$PROGRESS_DIV Performance Enhancements Applied ${STICKER_PROGRESS}"
# Tối ưu hóa GPU
gpu() {
setprop debug.hwui.renderer skiagl
setprop debug.gpu.renderer skiagl
setprop debug.renderengine.backend skiaglthreaded
setprop debug.angle.overlay FPS:Skiagl*PipelineCache*
setprop debug.composition.7x27A.type gpu
setprop debug.composition.7x25A.type gpu
setprop debug.velocitytracker.alt 0
setprop debug.tflite.trace 0
setprop debug.adbd.logging 0
setprop debug.sf.enable_egl_image_tracker false
setprop debug.stagefright.omx-debug 0
setprop debug.stagefright.profilecodec 0
setprop debug.debuggerd.wait_for_gdb false
setprop debug.cp2.scan_all_packages 0
setprop debug.tracing.screen_brightness 0
setprop debug.servicemanager.log_calls 0
setprop debug.hwui.print_config 0
setprop debug.choreographer.frametime false
setprop debug.sf.vsp_trace false
setprop debug.egl.trace 0
setprop debug.egl.finish false
setprop debug.sf.trace_hint_sessions false
setprop debug.sf.vsync_trace_detailed_info false
setprop debug.atrace.tags.enableflags 0
setprop debug.debuggerd.wait_for_debugger false
setprop debug.hwui.capture_skp_enabled false
setprop debug.renderengine.skia_atrace_enabled 0
setprop debug.mdpcomp.logs 0
setprop debug.graphics.gpu.profiler.perfetto 0
setprop debug.NewDatabasePerformanceTests.enable_wal false
setprop debug.hwui.skia_atrace_enabled 0
setprop debug.rs.profile 0
setprop debug.sf.dump 0
setprop debug.debuggerd.disable 1
setprop debug.hwc_dump_en 0
setprop debug.hwc.logvsync 0
setprop debug.malloc 0
setprop debug.enable.wl_log 0
setprop debug.tracing.battery_status 0
setprop debug.hwui.trace_gpu_resources false
setprop debug.hwui.skia_use_perfetto_track_events false
setprop debug.hwui.skia_tracing_enabled false
setprop debug.hwui.skip_eglmanager_telemetry true
setprop debug.renderengine.skia_use_perfetto_track_events false
setprop debug.tracing.ctl.renderengine.skia_tracing_enabled false
setprop debug.tracing.ctl.renderengine.skia_use_perfetto_track_events false
setprop debug.hwui.skp_filename false
setprop debug.sqlite.journalmode OFF
setprop debug.sqlite.syncmode OFF
setprop debug.sqlite.journalsizelimit 1mb
setprop debug.sqlite.wal.syncmode OFF
setprop debug.sf.dump.external false
setprop debug.sf.dump.primary false
setprop debug.sf.dump.png 0
setprop debug.checkjni 0
setprop debug.rs.script 0
setprop debug.rs.shader 0
setprop debug.sensors 0
setprop debug.hwui.profile false
setprop debug.layout false
setprop debug.generate-debug-info false
setprop debug.egl.traceGpuCompletion false
setprop debug.rs.shader.attributes 0
setprop debug.rs.shader.uniforms 0
setprop debug.rs.visual 0
setprop debug.egl.callstack false
setprop debug.orientation.log false
setprop debug.ld.all 0
setprop debug.hwui.level 0
setprop debug.contacts.ksad 0
setprop debug.sf.layerdump 0
setprop debug.ldbase 0
setprop debug.perfmond.atrace 0
setprop debug.sf.enable_transaction_tracing false
setprop debug.gles.layers 0
setprop debug.angle.validation false
setprop debug.sf.layer_history_trace false
setprop debug.sf.layer_caching_highlight false
setprop debug.jni.logging 0
setprop debug.orientation.log false
setprop debug.track-associations 0
setprop debug.tracing.screen_state 0
setprop debug.synclog 0
setprop debug.enable.sglscale 1
setprop debug.enable.gamed 1
setprop debug.enabletr true
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
setprop debug.sf.latch_unsignaled 1
setprop debug.sf.enable_gl_backpressure 1
setprop debug.egl.force_gpu 1
setprop debug.egl.swapinterval 1
setprop debug.composition.type gpu
setprop debug.disable.hwacc 0
setprop debug.sf.hw 1
setprop debug.als.logs 0
setprop debug.atrace.tags.enableflags 0
setprop debug.egl.profiler 0
setprop debug.enable.wl_log 0
setprop debug.sf.ddms 0
setprop debug.sf.dump 0
setprop debug.sf.no_vsync 1
setprop debug.mdpcomp.logs 0
setprop debug.hwui.force_fxaa 0
setprop debug.hwui.force_smaa 0
setprop debug.hwui.force_msaa 0
setprop debug.hwui.force_txaa 0
setprop debug.hwui.force_csaa 0
setprop debug.hwui.force_dlss 0
setprop debug.egl.force_msaa 0
setprop debug.egl.force_fxaa 0
setprop debug.egl.force_smaa 0
setprop debug.egl.force_txaa 0
setprop debug.egl.force_csaa 0
setprop debug.egl.force_dlss 0
setprop debug.sf.showfps 0
setprop debug.sf.showupdates 0
setprop debug.sf.showcpu 0
setprop debug.cpuprio 7
setprop debug.gpuprio 7  
setprop debug.ioprio 7
setprop debug.rs.max-threads 8
setprop debug.rs.min-threads 8
setprop debug.sf.mem_freq_index 2
setprop debug.sf.cpu_freq_index 2  
setprop debug.sf.gpu_freq_index 2
setprop debug.gr.swapinterval 0
setprop debug.sf.swapinterval 0
setprop debug.perf.tuning 1
setprop debug.enable-vr-mode 1
setprop debug.hwui.use_hint_manager 1
setprop debug.perf.profile 1
setprop debug.hwc.logvsync 0
setprop debug.sf.gpuoverlay 0   
setprop debug.performance.tuning 1
setprop debug.egl.swapinterval 0
setprop debug.cpurend.vsync false
setprop debug.gpurend.vsync false       
setprop debug.sf.hwc_disable_vsync 1
setprop debug.hwui.disable_vsync 1
setprop debug.gralloc.gfx_ubwc_disable false
setprop debug.composition.type c2d
setprop debug.composition.type gpu
setprop debug.performance_schema 1
setprop debug.performance_schema_max_memory_classes 387
setprop debug.sf.enable_advanced_sf_phase_offset 0
setprop debug.sf.enable_hwc_vds 1
setprop debug.hwui.render_dirty_regions false
setprop debug.sf.enable_gl_backpressure 1
setprop debug.sf.disable_backpressure 1
setprop debug.performance.boost 1
setprop debug.performance.governor performance
setprop debug.performance.inputthread 1
setprop debug.performance.io unlimited
setprop debug.performance.liquidgfx 1
setprop debug.performance.memory 1
setprop debug.performance.navigation 1
setprop debug.performance.profile 1
setprop debug.MB.running 0
setprop debug.MB.inner.running 100
setprop debug.power_management_mode perf_max
setprop debug.disable.hwacc 0
setprop debug.enable.gamed 0
settings put global cpu.core_limit_background 1
settings put global cpu.core_limit_foreground 4  
settings put global device_provisioned 1
setprop debug.hwui.profiler.cgroups_cpu.force_enabled 1
setprop debug.hwui.dynamic_resource_cache 1
setprop debug.frame_rate_cap 1
setprop debug.hwui.target_cpu_time_percent 200  
setprop debug.hwui.target_gpu_time_percent 200  
}
gpu > /dev/null 2>&1  

echo "$PROGRESS_DIV GPU Optimization Completed ${STICKER_PROGRESS}"
# Kiểm soát nhiệt độ
cpu() {
setprop debug.gpu.cooling.callback_freq_limit 0
setprop debug.cpu.cooling.callback_freq_limit 0    
setprop debug.thermal.temperature.threshold 42  
settings put global normal_mode_temperature 38
settings put global gaming_mode_temperature 40
settings put global temp_limit_max 42 
setprop debug.gpu.renderer skiagl
setprop debug.hwui.renderer skiagl
setprop debug.hwui.use_threaded_renderer true
setprop debug.hwui.shadow.renderer opengl
setprop debug.renderengine.backend opengl
setprop debug.hwui.renderer.opengl true
setprop debug.thermal.management 1
setprop debug.thermal.throttling 1
setprop debug.thermal.temperature.threshold 40  
settings put global performance_profile high_performance
}
cpu > /dev/null 2>&1  

echo "$PROGRESS_DIV Thermal Management Configured ${STICKER_PROGRESS}"
nhay() {    
# Tối ưu hóa cảm ứng
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
settings put secure double_tap_timeout 200
settings put secure multi_press_timeout 300
settings put secure long_press_timeout 350
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
settings put secure touch_resampling_rate 720
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
}
nhay > /dev/null 2>&1  
echo "$PROGRESS_DIV Touch Input Optimization Completed ${STICKER_PROGRESS}"
# Tối ưu hóa chế độ chơi game   
game() {
dumpsys battery set level 100
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
}
game > /dev/null 2>&1  
for tag in system_server system_server/Subject data_app_wtf storage_trim SYSTEM_BOOT SYSTEM_AUDIT system_server_wtf SYSTEM_LAST_KMSG; do
    cmd dropbox add-low-priority "$tag"
done
cmd dropbox set-rate-limit 99999999999999
settings put global dropbox_age_seconds 0
settings put global dropbox_max_files 0
echo "$PROGRESS_DIV Game Mode Optimization Initiated ${STICKER_PROGRESS}"
echo "[2/4] Đang tối ưu..."
for dcx in odp_enable_client_error_logging fcp_enable_client_error_logging odp_background_jobs_logging_enabled fcp_enable_background_jobs_logging; do
    value=$(device_config get on_device_personalization "$dcx")
    if [ "$value" != "null" ] && [ -n "$value" ]; then
        device_config put on_device_personalization "$dcx" false
    fi
done
echo "[3/4] Đang tối ưu..."
for key in measurement_verbose_debug_reporting_job_required_network_type measurement_debug_reporting_fallback_job_required_network_type measurement_debug_reporting_job_required_network_type measurement_aggregate_fallback_reporting_job_required_network_type measurement_aggregate_reporting_job_required_network_type measurement_async_registration_fallback_job_required_network_type measurement_async_registration_queue_job_required_network_type measurement_event_fallback_reporting_job_required_network_type measurement_event_reporting_job_required_network_type; do
    value=$(device_config get adservices "$key")
    if [ "$value" != "null" ] && [ -n "$value" ]; then
        device_config put adservices "$key" 0
    fi
done
echo "[4/4] Đang tối ưu ..."
for key in adservice_system_service_enabled cobalt_logging_enabled enable_logged_topic adservice_error_logging_enabled measurement_enable_app_package_name_logging measurement_enable_source_debug_report fledge_app_package_name_logging fledge_auction_server_enable_debug_reporting fledge_auction_server_api_usage_metrics_enabled fledge_auction_server_enabled_for_report_event fledge_auction_server_enabled_for_report_impression fledge_auction_server_enabled_for_select_ads_mediation; do
    value=$(device_config get adservices "$key")
    if [ "$value" != "null" ] && [ -n "$value" ]; then
        device_config put adservices "$key" false
    fi
done
echo "$PROGRESS_DIV Background Services Optimized ${STICKER_PROGRESS}"
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
  cmd device_config put game_overlay "$package" mode=2,fps=120,useAngle=true
  cmd package compile -m speed-profile -f "$package"
done
}
tro > /dev/null 2>&1  
echo "$DIVIDER"
echo "$STICKER_COMPLETION$(pad_text "OPTIMIZATION COMPLETED")"
echo "$SECTION_DIV"
echo "$PROGRESS_DIV Enhanced Performance Achieved ${STICKER_COMPLETION}"
echo "$PROGRESS_DIV Device Stability Ensured, Lag Reduced ${STICKER_COMPLETION}"
echo "$PROGRESS_DIV Follow Us: YouTube - GRAP FIFA 🎮"
echo "$DIVIDER"
cmd notification post -t "🔥UltraV3🔥" -S inbox \
    --line "Tăng hiệu suất cao ☑" \
    --line "Ổn định thiết bị, giảm nóng và lag ☑" \
    --line "YouTube: UltraV1 🎮" \
    myTag "Game Gaming" >/dev/null
