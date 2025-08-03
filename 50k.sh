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
echo "|          Module: ZERO V3              |"
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
echo " * Bắt đầu chạy code * "
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
if [ "$refresh_rate" -eq 60 ]; then
    setprop debug.sf.early.app.duration 20000000
    setprop debug.sf.early.sf.duration 16666666
    setprop debug.sf.earlyGl.app.duration 20000000
    setprop debug.sf.earlyGl.sf.duration 16666666
    setprop debug.sf.late.app.duration 16666666
    setprop debug.sf.late.sf.duration 20000000
elif [ "$refresh_rate" -eq 90 ]; then
    setprop debug.sf.early.app.duration 12500000
    setprop debug.sf.early.sf.duration 11111111
    setprop debug.sf.earlyGl.app.duration 12500000
    setprop debug.sf.earlyGl.sf.duration 11111111 
    setprop debug.sf.late.app.duration 11111111
    setprop debug.sf.late.sf.duration 12500000
elif [ "$refresh_rate" -eq 120 ]; then
    setprop debug.sf.early.app.duration 10500000
    setprop debug.sf.early.sf.duration 8333333
    setprop debug.sf.earlyGl.app.duration 10500000
    setprop debug.sf.earlyGl.sf.duration 8333333
    setprop debug.sf.late.app.duration 8333333
    setprop debug.sf.late.sf.duration 10500000
elif [ "$refresh_rate" -eq 144 ]; then
    setprop debug.sf.early.app.duration 8500000
    setprop debug.sf.early.sf.duration 6944444
    setprop debug.sf.earlyGl.app.duration 8500000
    setprop debug.sf.earlyGl.sf.duration 6944444
    setprop debug.sf.late.app.duration 6944444
    setprop debug.sf.late.sf.duration 8500000
else
    echo "Tần số quét không xác định được ⚠"
fi
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
settings put global window_animation_scale 0.5
settings put global transition_animation_scale 0.5
settings put global animator_duration_scale 0.5
settings put system game-touchscreen-boost 1
settings put system touch.pressure.scale 0.001
settings put system touch_boost 1
settings put system ram_boost 1
settings put secure long_press_timeout 350
settings put secure multi_press_timeout 250
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
setprop debug.hwc.logvsync 0
setprop debug.sf.gpuoverlay 0
setprop debug.sf.sa_enable 1
setprop debug.qc.hardware 1
setprop debug.sf.sa_log 1
setprop debug.hwc.asyncdisp 1
setprop debug.power.loghint 0
setprop debug.force-opengl 1
setprop debug.cpuprio 7
setprop debug.gpuprio 7
setprop debug.ioprio 7
setprop debug.hwui.fps_divisor 1
setprop debugtool.anrhistory 0
setprop debug.cpurend.vsync false
setprop debug.gpurend.vsync false
setprop debug.performance.tuning 1
setprop debug.perf.tuning 1
setprop debug.enable-vr-mode 1
setprop debug.performance.profile 1
setprop debug.perf.profile 1
setprop debug.hwui.use_layer_renderer true
setprop debug.hwui.target_cpu_time_percent 100
setprop debug.hwui.target_gpu_time_percent 100
}
pe > /dev/null 2>&1  
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
  cmd device_config put game_overlay "$package" mode=2,fps=$refresh_rate,useAngle=true
done
}
game > /dev/null 2>&1  
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
cmd game set --fps $refresh_rate --mode 2 --downscale 0.7 com.dts.freefiremax
cmd game set --fps $refresh_rate --mode 2 --downscale 0.7 com.dts.freefireth
}
ff > /dev/null 2>&1  
echo "Success☑️" 
echo "Vui lòng không khởi động lại máy sẽ mất tác dụng"
echo "Vào game test thôi🎮"
cmd notification post -t "🔥ZERO V3🔥" -S inbox \
    --line "Tăng hiệu suất cao ☑" \
    --line "Ổn định thiết bị, giảm nóng và lag ☑" \
    --line "Tăng nhạy ổn định☑" \
    --line "YouTube: GRAP FIFA 🎮" \
    myTag "Game Gaming" >/dev/null
