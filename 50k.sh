#!/system/bin/sh
dev=grapfifa
refresh_rate=$(dumpsys SurfaceFlinger | grep "refresh-rate" | awk '{printf("%d ", $3)}')
brand=$(getprop ro.product.brand)
hardware=$(getprop ro.hardware)
android=$(getprop ro.build.version.release)
bit=$(getprop ro.product.cpu.abi)
cores=$(cat /proc/cpuinfo | grep "processor" | wc -l)
kb_ram=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
gb_ram=$(echo "scale=2; $kb_ram / 1048576" | bc)
ram_info=$(cat /proc/meminfo | grep -E "MemTotal|MemAvailable" | \
awk 'NR==1{total=$2} NR==2{available=$2} END{printf "%.2f / %.2f GB", available/1024/1024, total/1024/1024}')
storage=$(df /data | awk 'NR==2 { total=($2+$3)/1024/1024; used=$3/1024/1024; printf "%.2f / %.0f GB", used, total }')
ping=$(ping -c 1 8.8.8.8 | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1 || echo "N/A")
sleep 1

echo "========================================="
echo "|          Module: ZERO V2              |"
echo "========================================="
printf "| Dev         : %-22s |\n" "$dev"
printf "| Status      : %-22s |\n" "No Root"
printf "| Brand       : %-22s |\n" "$brand"
printf "| Android     : %-22s |\n" "$android"
printf "| BitCheck    : %-22s |\n" "$bit"
printf "| ZALO        : %-22s |\n" "ThangLe"
printf "| MONEY       : %-22s |\n" "50k"
echo "-----------------------------------------"
printf "| CPU         : %-22s |\n" "$cores cores"
printf "| RAM         : %-22s |\n" "$ram_info"
printf "| Storage     : %-22s |\n" "$storage"
printf "| Network     : %-22s |\n" "$ping ms"
printf "| Screen      : %-22s |\n" "$refresh_rate Hz"
echo "========================================="
echo "→ [Tăng hiệu suất]       "
echo "→ [Tối ưu RAM]         "
echo "→ [Tối ưu CPU và GPU]           "
echo "→ [Tối ưu FPS]           "
echo "→ [Tăng nhạy cảm ứng]"
echo "→ [Giảm Rung tâm]"
echo "→ [Tối ưu trò chơi]"
echo "→ [Dọn dẹp bộ nhớ]"
echo "========================================="
echo " * Wait For Install * "
refresh_rate=$(dumpsys SurfaceFlinger | grep refresh-rate | awk -F': ' '{print $2}' | awk '{print int($1+0.5)}')
echo "  Display Refresh Rate: ${refresh_rate}Hz"
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
}> /dev/null 2>&1  
log
echo "[3/3] Log Suppression Applied "
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
cmd power set-fixed-performance-mode-enabled true
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
settings put system ro.min.fling_velocity 25000
settings put system ro.max.fling_velocity 25000
settings put system speed_pointer 7
settings put system game-touchscreen-boost 1
settings put system touch.pressure.scale 0.001
settings put system touch_boost 1
settings put system ram_boost 1
settings put secure long_press_timeout 500
settings put secure multi_press_timeout 500
settings put secure speed_mode 1
settings put secure speed_mode_enable 1
setprop hwui.render_dirty_regions 0
setprop debug.sf.hw 1
setprop debug.als.logs 0
setprop debug.atrace.tags.enableflags 0
setprop debug.egl.profiler 0
setprop debug.enable.wl_log 0
setprop debug.sf.enable_hwc_vds 0
setprop debug.mdpcomp.logs 0
setprop debug.egl.force_msaa 0
setprop debug.hwui.force_fxaa 0 
setprop debug.hwui.force_smaa 0 
setprop debug.hwui.force_msaa 0 
setprop debug.hwui.force_txaa 0 
setprop debug.hwui.force_csaa 0 
setprop debug.hwui.force_dlss 0 
setprop debug.gr.swapinterval 0
setprop debug.sf.swapinterval 0
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
setprop debug.composition.type gpu
setprop debug.egl.swapinterval 0
setprop debug.gpu.renderer skiagl
setprop debug.hwui.renderer skiagl
setprop debug.hwui.use_threaded_renderer true
setprop debug.hwc.logvsync 0
setprop debug.sf.gpuoverlay 0
setprop debug.sf.sa_enable 1
setprop debug.qc.hardware 1
setprop debug.sqlite.journalmode WAL
setprop debug.sf.sa_log 1
setprop debug.hwc.asyncdisp 1
setprop debug.power.loghint 0
setprop debug.force-opengl 1
setprop debug.cpuprio 7
setprop debug.gpuprio 7
setprop debug.ioprio 7
setprop debug.hwui.fps_divisor 1
setprop debugtool.anrhistory 0
setprop debug.hwc.force_gpu_vsync 1
setprop debug.sf.gpu_comp_tiling 1
setprop debug.javafx.animation.fullspeed true
setprop debug.cpurend.vsync false
setprop debug.gpurend.vsync false
setprop debug.performance.tuning 1
setprop debug.perf.tuning 1
setprop debug.enable-vr-mode 1
setprop debug.performance.profile 1
setprop debug.perf.profile 1
setprop debug.hwui.use_layer_renderer true
setprop debug.hwui.target_cpu_time_percent 200
setprop debug.hwui.target_gpu_time_percent 200
setprop pm.dexopt.bg-dexopt speed-profile
setprop pm.dexopt.ab-ota speed-profile
settings delete global updatable_driver_production_opt_in_apps
settings delete global game_driver_opt_in_apps
settings delete global updatable_driver_production_opt_out_apps
settings delete global updatable_driver_prerelease_opt_in_apps
settings delete global updatable_driver_all_apps
settings delete global updatable_driver_production_in_out_apps
}> /dev/null 2>&1  
pe
game() { 
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
done
}> /dev/null 2>&1  
game
size=$(wm size | grep -oE '[0-9]+x[0-9]+')
dpi=$(wm density | grep -oE '[0-9]+')
if [ -z "$dpi" ]; then
  echo "❌ Không lấy được DPI. Thoát..."
  exit 1
fi
width=$(echo "$size" | cut -d'x' -f1)
height=$(echo "$size" | cut -d'x' -f2)
compare=$(echo "$dpi < 400" | bc)
if [ "$compare" -eq 1 ]; then
  scale=1.1
  echo "🔧 Buff màn hình lên $scale"
else
  scale=0.9
  echo "⚙️ Giảm độ phân giải xuống $scale"
fi
new_width=$(echo "$width * $scale" | bc | cut -d'.' -f1)
new_height=$(echo "$height * $scale" | bc | cut -d'.' -f1)
wm size ${new_width}x${new_height}
echo "✅ Kích thước màn hình đã đổi: ${new_width}x${new_height}"
echo "Success☑️" 
echo "Vui lòng không khởi động lại máy sẽ mất tác dụng"
echo "Vào game test thôi🎮"
cmd notification post -t "🔥ZERO V2🔥" -S inbox \
    --line "Tăng hiệu suất cao ☑" \
    --line "Ổn định thiết bị, giảm nóng và lag ☑" \
    --line "Tăng nhạy ổn định☑" \
    --line "YouTube: GRAP FIFA 🎮" \
    myTag "Game Gaming" >/dev/null
