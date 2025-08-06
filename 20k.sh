#!/system/bin/sh
echo "┌──────────────────────────────┐"
echo "│ 🚀 Module: UltraGR V2 🚀     │"
echo "├──────────────────────────────┤"
echo "⌐╦╦═─ • DEV: GRAP FIFA / YTB: GRAP FIFA ⌐╦╦═─"
echo "    ꧁/ Chức năng chính /꧂"
echo "│ • Tăng tốc hệ thống          │"
echo "│ • Giảm độ trễ, tối ưu game   │"
echo "│ • Tăng nhạy ổn định          |"
echo "│ • Hỗ trợ mọi thiết bị Android│"
echo "└──────────────────────────────┘"
sleep 1
thietbi() {
# Thu thập thông tin thiết bị
MODEL=$(getprop ro.product.model 2>/dev/null || echo "N/A")
BRAND=$(getprop ro.product.brand 2>/dev/null || echo "N/A")
DEVICE=$(getprop ro.product.device 2>/dev/null || echo "N/A")
MANUFACTURER=$(getprop ro.product.manufacturer 2>/dev/null || echo "N/A")
ANDROID_VER=$(getprop ro.build.version.release 2>/dev/null || echo "N/A")
SDK_VER=$(getprop ro.build.version.sdk 2>/dev/null || echo "N/A")
CPU=$(getprop ro.board.platform 2>/dev/null || echo "N/A")
ARCH=$(getprop ro.product.cpu.abi 2>/dev/null || echo "N/A")
GPU=$(dumpsys SurfaceFlinger | grep GLES | cut -d':' -f2 | sed 's/^ *//' 2>/dev/null || echo "N/A")
RESOLUTION=$(wm size | awk '{print $3}' 2>/dev/null || echo "N/A")
RAM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{printf "%.1f GB", $2/1048576}' 2>/dev/null || echo "N/A")
CPU_CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || echo "N/A")
BOARD=$(getprop ro.product.board 2>/dev/null || echo "N/A")
}
thietbi > /dev/null 2>&1   
# Hiển thị thông tin thiết bị
echo ""
echo "┌─────────[ Thiết bị ]─────────"
echo "│ Model   : $MODEL ($BRAND)    "
echo "│ Nhà sx  : $MANUFACTURER      "
echo "│ Android : $ANDROID_VER (SDK $SDK_VER) "
echo "│ CPU     : $CPU ($ARCH)       "
echo "│ Nhân    : $CPU_CORES cores   "
echo "│ GPU     : $GPU               "
echo "│ RAM     : $RAM_TOTAL         "
echo "│ Màn hình: $RESOLUTION        "
echo "│ Bo mạch : $BOARD             "
printf "│ Ngày    : %s\n" "$(date '+%d/%m/%Y')"
printf "│ Giờ     : %s\n" "$(date '+%H:%M')"
echo "└──────────────────────────────"
sleep 1

# Thanh tiến trình tối ưu hóa
echo ""
echo "┌──[ Đang tối ưu hóa ]──┐"
for i in $(seq 1 5); do
  BAR=$(printf "%0.s█" $(seq 1 $i))
  EMPTY=$(printf "%0.s " $(seq 1 $((5 - $i))))
  PERCENT=$((i * 20))
  printf "│ [%-5s] %3d%% │\n" "$BAR$EMPTY" "$PERCENT"
  sleep 0.2
done
calc_duration() {
    echo "scale=0; $1 * $2 / 1" | bc
}
calc_duration > /dev/null 2>&1  

# Lấy refresh rate, làm tròn về số nguyên
refresh_rate=$(dumpsys SurfaceFlinger 2>/dev/null | grep -m 1 "refresh-rate" \
  | awk -F': ' '{print $2}' | awk '{print int($1+0.5)}')

# nếu không lấy được refresh rate
if [ -z "$refresh_rate" ]; then
    echo "Lỗi: không thể lấy được Refresh Rate của máy, Đặt mặc định 60hz"
    refresh_rate=60
fi

echo "Refresh Rate hiện tại: ${refresh_rate}Hz"

# Tính frame time (nanosecond cho 1 frame)
frame_ns=$(echo "scale=0; 1000000000 / $refresh_rate" | bc)

# Các hệ số timing
early_app_factor=0.48
early_sf_factor=0.26
earlyGl_app_factor=0.42
earlyGl_sf_factor=0.22
late_app_factor=0.08
late_sf_factor=0.06
min_hwc_factor=0.05

# Tính duration
early_app=$(calc_duration "$frame_ns" "$early_app_factor")
early_sf=$(calc_duration "$frame_ns" "$early_sf_factor")
earlyGl_app=$(calc_duration "$frame_ns" "$earlyGl_app_factor")
earlyGl_sf=$(calc_duration "$frame_ns" "$earlyGl_sf_factor")
late_app=$(calc_duration "$frame_ns" "$late_app_factor")
late_sf=$(calc_duration "$frame_ns" "$late_sf_factor")
min_hwc=$(calc_duration "$frame_ns" "$min_hwc_factor")

# Phase offset (âm)
early_app_phase=$(echo "-$early_app" | bc)
early_sf_phase=$(echo "-$early_sf" | bc)
earlyGl_app_phase=$(echo "-$earlyGl_app" | bc)
earlyGl_phase=$(echo "-$earlyGl_sf" | bc)
late_app_phase=$(echo "-$late_app" | bc)
late_sf_phase=$(echo "-$late_sf" | bc)
fps() {
# Danh sách property cần set
fps_props=(
  "debug.sf.early.app.duration $early_app"
  "debug.sf.early.sf.duration $early_sf"
  "debug.sf.earlyGl.app.duration $earlyGl_app"
  "debug.sf.earlyGl.sf.duration $earlyGl_sf"
  "debug.sf.late.app.duration $late_app"
  "debug.sf.late.sf.duration $late_sf"
  "debug.sf.high_fps.early.app.duration $early_app"
  "debug.sf.high_fps.early.sf.duration $early_sf"
  "debug.sf.high_fps.earlyGl.app.duration $earlyGl_app"
  "debug.sf.high_fps.earlyGl.sf.duration $earlyGl_sf"
  "debug.sf.high_fps.late.app.duration $late_app"
  "debug.sf.high_fps.late.sf.duration $late_sf"
  "debug.sf.high_fps.hwc.min.duration $min_hwc"
  "debug.sf.early_app_phase_offset_ns $early_app_phase"
  "debug.sf.early_sf_phase_offset_ns $early_sf_phase"
  "debug.sf.early_gl_app_phase_offset_ns $earlyGl_app_phase"
  "debug.sf.early_gl_phase_offset_ns $earlyGl_phase"
  "debug.sf.late_app_phase_offset_ns $late_app_phase"
  "debug.sf.late_sf_phase_offset_ns $late_sf_phase"
  "debug.sf.high_fps_early_app_phase_offset_ns $early_app_phase"
  "debug.sf.high_fps_early_sf_phase_offset_ns $early_sf_phase"
  "debug.sf.high_fps_early_gl_app_phase_offset_ns $earlyGl_app_phase"
  "debug.sf.high_fps_early_gl_phase_offset_ns $earlyGl_phase"
  "debug.sf.high_fps_late_app_phase_offset_ns $late_app_phase"
  "debug.sf.high_fps_late_sf_phase_offset_ns $late_sf_phase"
)

echo "🎯 Tối ưu SurfaceFlinger Giúp giảm drop khung hình."
# Set từng prop
for prop in "${fps_props[@]}"; do
  echo $prop
done

echo "Done."
}
fps > /dev/null 2>&1  
tweaks() {
    disable_log=(
        "log.tag.AF::MmapTrack V"
        "log.tag.AF::OutputTrack V"
        "log.tag.AF::PatchRecord V"
        "log.tag.AF::PatchTrack V"
        "log.tag.AF::RecordHandle V"
        "log.tag.AF::RecordTrack V"
        "log.tag.AF::Track V"
        "log.tag.AF::TrackBase V"
        "log.tag.AF::TrackHandle V"
        "log.tag.APM-KpiMonitor V"
        "log.tag.APM-ServiceJ V"
        "log.tag.APM-SessionJ V"
        "log.tag.APM-SessionN V"
        "log.tag.APM-Subscriber V"
        "log.tag.APM::AudioCollections V"
        "log.tag.APM::AudioInputDescriptor V"
        "log.tag.APM::AudioOutputDescriptor V"
        "log.tag.APM::AudioPatch V"
        "log.tag.APM::AudioPolicyEngine V"
        "log.tag.APM::AudioPolicyEngine::Base V"
        "log.tag.APM::AudioPolicyEngine::Config V"
        "log.tag.APM::AudioPolicyEngine::ProductStrategy V"
        "log.tag.APM::AudioPolicyEngine::VolumeGroup V"
        "log.tag.APM::Devices V"
        "log.tag.APM::IOProfile V"
        "log.tag.APM::Serializer V"
        "log.tag.APM::VolumeCurve V"
        "log.tag.APM_AudioPolicyManager V"
        "log.tag.APM_ClientDescriptor V"
        "log.tag.AT V"
        "log.tag.AccountManager V"
        "log.tag.ActivityManager V"
        "log.tag.ActivityManagerService V"
        "log.tag.ActivityTaskManager V"
        "log.tag.ActivityTaskManagerService V"
        "log.tag.AdnRecord V"
        "log.tag.AdnRecordCache V"
        "log.tag.AdnRecordLoader V"
        "log.tag.AirplaneHandler V"
        "log.tag.AlarmManager V"
        "log.tag.AlarmManagerService V"
        "log.tag.AndroidRuntime V"
        "log.tag.AppOps V"
        "log.tag.AudioAttributes V"
        "log.tag.AudioEffect V"
        "log.tag.AudioFlinger V"
        "log.tag.AudioFlinger::DeviceEffectProxy V"
        "log.tag.AudioFlinger::DeviceEffectProxy::ProxyCallback V"
        "log.tag.AudioFlinger::EffectBase V"
        "log.tag.AudioFlinger::EffectChain V"
        "log.tag.AudioFlinger::EffectHandle V"
        "log.tag.AudioFlinger::EffectModule V"
        "log.tag.AudioFlinger_Threads V"
        "log.tag.AudioHwDevice V"
        "log.tag.AudioManager V"
        "log.tag.AudioPolicy V"
        "log.tag.AudioPolicyEffects V"
        "log.tag.AudioPolicyIntefaceImpl V"
        "log.tag.AudioPolicyManager V"
        "log.tag.AudioPolicyService V"
        "log.tag.AudioProductStrategy V"
        "log.tag.AudioRecord V"
        "log.tag.AudioService V"
        "log.tag.AudioSystem V"
        "log.tag.AudioTrack V"
        "log.tag.AudioTrackShared V"
        "log.tag.AudioVolumeGroup V"
        "log.tag.BackupManager V"
        "log.tag.BatteryManager V"
        "log.tag.BatteryStatsService V"
        "log.tag.BluetoothAdapter V"
        "log.tag.BluetoothDevice V"
        "log.tag.BluetoothGattService V"
        "log.tag.BluetoothHidService V"
        "log.tag.BluetoothManager V"
        "log.tag.BluetoothMapService V"
        "log.tag.BluetoothPanService V"
        "log.tag.BluetoothPbapService V"
        "log.tag.BluetoothSapService V"
        "log.tag.BluetoothService V"
        "log.tag.BluetoothSocket V"
        "log.tag.BufferQueueDump V"
        "log.tag.BufferQueueProducer V"
        "log.tag.C2K_AT V"
        "log.tag.C2K_ATConfig V"
        "log.tag.C2K_RILC V"
        "log.tag.CAM2PORT_ V"
        "log.tag.CapaSwitch V"
        "log.tag.CarrierExpressServiceImpl V"
        "log.tag.CarrierExpressServiceImplExt V"
        "log.tag.ClipboardManager V"
        "log.tag.ConnectivityManager V"
        "log.tag.ConnectivityService V"
        "log.tag.ConsumerIrService V"
        "log.tag.ContentManager V"
        "log.tag.CountryDetector V"
        "log.tag.DMC-ApmService V"
        "log.tag.DMC-Core V"
        "log.tag.DMC-DmcService V"
        "log.tag.DMC-EventsSubscriber V"
        "log.tag.DMC-ReqQManager V"
        "log.tag.DMC-SessionManager V"
        "log.tag.DMC-TranslatorLoader V"
        "log.tag.DMC-TranslatorUtils V"
        "log.tag.DSSelector V"
        "log.tag.DSSelectorOP01 V"
        "log.tag.DSSelectorOP02 V"
        "log.tag.DSSelectorOP09 V"
        "log.tag.DSSelectorOP18 V"
        "log.tag.DSSelectorOm V"
        "log.tag.DSSelectorUtil V"
        "log.tag.DataDispatcher V"
        "log.tag.DeviceIdleController V"
        "log.tag.DevicePolicyManager V"
        "log.tag.DevicePolicyManagerService V"
        "log.tag.DisplayManager V"
        "log.tag.DisplayManagerService V"
        "log.tag.DockObserver V"
        "log.tag.DownloadManager V"
        "log.tag.ExternalSimMgr V"
        "log.tag.FastCapture V"
        "log.tag.FastMixer V"
        "log.tag.FastMixerState V"
        "log.tag.FastThread V"
        "log.tag.FragmentManager V"
        "log.tag.FuseDaemon V"
        "log.tag.GAv4 V"
        "log.tag.GraphicsStats V"
        "log.tag.GsmCallTkrHlpr V"
        "log.tag.GsmCdmaConn V"
        "log.tag.GsmCdmaPhone V"
        "log.tag.HardwarePropertiesManager V"
        "log.tag.HardwareService V"
        "log.tag.IAudioFlinger V"
        "log.tag.IMSRILRequest V"
        "log.tag.IMS_RILA V"
        "log.tag.IccCardProxy V"
        "log.tag.IccPhoneBookIM V"
        "log.tag.IccProvider V"
        "log.tag.ImsApp V"
        "log.tag.ImsBaseCommands V"
        "log.tag.ImsCall V"
        "log.tag.ImsCallProfile V"
        "log.tag.ImsCallSession V"
        "log.tag.ImsEcbm V"
        "log.tag.ImsEcbmProxy V"
        "log.tag.ImsManager V"
        "log.tag.ImsPhone V"
        "log.tag.ImsPhoneBase V"
        "log.tag.ImsPhoneCall V"
        "log.tag.ImsService V"
        "log.tag.ImsVTProvider V"
        "log.tag.InputDispatcher V"
        "log.tag.InputManager V"
        "log.tag.InputManagerService V"
        "log.tag.InputMethodManager V"
        "log.tag.InputMethodManagerService V"
        "log.tag.InterfaceManager V"
        "log.tag.IsimFileHandler V"
        "log.tag.IsimRecords V"
        "log.tag.JobScheduler V"
        "log.tag.KeyguardManager V"
        "log.tag.LCM-Subscriber V"
        "log.tag.LIBC2K_RIL V"
        "log.tag.LocationManager V"
        "log.tag.LocationManagerService V"
    )
    for commands in "${disable_log[@]}"; do
    IFS=' ' read -r name value <<< "$commands"
    setprop "$name" "$value"
done
}
tweaks > /dev/null 2>&1  
ram() {
frequency=$(cat /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq)
if [ $frequency -ge 3000000 ]; then
setprop debug.hwui.texture_max_size 65536
setprop debug.hwui.texture_cache_size 65536
setprop debug.hwui.layer_cache_size 65536
setprop debug.hwui.path_cache_size 65536
setprop debug.hwui.gradient_cache_size 65536
setprop debug.hwui.drop_shadow_cache_size 65536
setprop debug.hwui.cache_size 65536
setprop debug.hwui.gradient_cache_size 65536
setprop debug.hwui.render_pipeline_cache_size 65536
setprop debug.hwui.cache_size 65536
setprop debug.hwui.resource_cache_size 65536
setprop debug.hwui.fbo_cache_size 65536
setprop debug.hwui.pipeline_cache_size 65536
setprop debug.hwui.buffer_cache_size 65536
setprop debug.hwui.layer_pool_size 65536
setprop debug.hwui.r_buffer_cache_size 65536
elif [ $frequency -ge 2700000 ]; then
setprop debug.hwui.texture_max_size 32768
setprop debug.hwui.texture_cache_size 32768
setprop debug.hwui.layer_cache_size 32768
setprop debug.hwui.path_cache_size 32768
setprop debug.hwui.gradient_cache_size 32768
setprop debug.hwui.drop_shadow_cache_size 32768
setprop debug.hwui.cache_size 32768
setprop debug.hwui.gradient_cache_size 32768
setprop debug.hwui.render_pipeline_cache_size 32768
setprop debug.hwui.cache_size 32768
setprop debug.hwui.resource_cache_size 32768
setprop debug.hwui.fbo_cache_size 32768
setprop debug.hwui.pipeline_cache_size 32768
setprop debug.hwui.buffer_cache_size 32768
setprop debug.hwui.layer_pool_size 32768
setprop debug.hwui.r_buffer_cache_size 32768
elif [ $frequency -ge 2400000 ]; then
setprop debug.hwui.texture_max_size 16384
setprop debug.hwui.texture_cache_size 16384
setprop debug.hwui.layer_cache_size 16384
setprop debug.hwui.path_cache_size 16384
setprop debug.hwui.gradient_cache_size 16384
setprop debug.hwui.drop_shadow_cache_size 16384
setprop debug.hwui.cache_size 16384
setprop debug.hwui.gradient_cache_size 16384
setprop debug.hwui.render_pipeline_cache_size 16384
setprop debug.hwui.cache_size 16384
setprop debug.hwui.resource_cache_size 16384
setprop debug.hwui.fbo_cache_size 16384
setprop debug.hwui.pipeline_cache_size 16384
setprop debug.hwui.buffer_cache_size 16384
setprop debug.hwui.layer_pool_size 16384 
setprop debug.hwui.r_buffer_cache_size 16384
elif [ $frequency -ge 2100000 ]; then
setprop debug.hwui.texture_max_size 8192
setprop debug.hwui.texture_cache_size 8192
setprop debug.hwui.layer_cache_size 8192
setprop debug.hwui.path_cache_size 8192
setprop debug.hwui.gradient_cache_size 8192
setprop debug.hwui.drop_shadow_cache_size 8192
setprop debug.hwui.cache_size 8192
setprop debug.hwui.gradient_cache_size 8192
setprop debug.hwui.render_pipeline_cache_size 8192
setprop debug.hwui.cache_size 8192
setprop debug.hwui.resource_cache_size 8192
setprop debug.hwui.fbo_cache_size 8192
setprop debug.hwui.pipeline_cache_size 8192
setprop debug.hwui.buffer_cache_size 8192
setprop debug.hwui.layer_pool_size 8192 
setprop debug.hwui.r_buffer_cache_size 8192
elif [ $frequency -ge 1900000 ]; then
setprop debug.hwui.texture_max_size 4096
setprop debug.hwui.texture_cache_size 4096
setprop debug.hwui.layer_cache_size 4096
setprop debug.hwui.path_cache_size 4096
setprop debug.hwui.gradient_cache_size 4096
setprop debug.hwui.drop_shadow_cache_size 4096
setprop debug.hwui.cache_size 4096
setprop debug.hwui.gradient_cache_size 4096
setprop debug.hwui.render_pipeline_cache_size 4096
setprop debug.hwui.cache_size 4096
setprop debug.hwui.resource_cache_size 4096
setprop debug.hwui.fbo_cache_size 4096
setprop debug.hwui.pipeline_cache_size 4096
setprop debug.hwui.buffer_cache_size 4096
setprop debug.hwui.layer_pool_size 4096  
setprop debug.hwui.r_buffer_cache_size 4096
else
setprop debug.hwui.texture_max_size 16384
setprop debug.hwui.texture_cache_size 16384
setprop debug.hwui.layer_cache_size 2048
setprop debug.hwui.path_cache_size 2048
setprop debug.hwui.gradient_cache_size 2048
setprop debug.hwui.drop_shadow_cache_size 2048
setprop debug.hwui.cache_size 2048
setprop debug.hwui.gradient_cache_size 16384
setprop debug.hwui.render_pipeline_cache_size 2048
setprop debug.hwui.cache_size 2048
setprop debug.hwui.resource_cache_size 16384
setprop debug.hwui.fbo_cache_size 2048
setprop debug.hwui.pipeline_cache_size 2048
setprop debug.hwui.buffer_cache_size 2048
setprop debug.hwui.layer_pool_size 2048
setprop debug.hwui.r_buffer_cache_size 2048
fi
}
ram > /dev/null 2>&1  
game() {
settings put global device_idle_constants inactive_to=25000,sensing_to=0,locating_to=0,location_accuracy=20.0,motion_inactive_to=0,idle_after_inactive_to=0,idle_pending_to=60000,max_idle_pending_to=120000,idle_pending_factor=2.0,idle_to=900000,max_idle_to=21600000,idle_factor=2.0,min_time_to_alarm=600000,max_temp_app_whitelist_duration=10000,mms_temp_app_whitelist_duration=10000,sms_temp_app_whitelist_duration=10000,light_after_inactive_to=5000,light_pre_idle_to=60000,light_idle_to=180000,light_idle_factor=2.0,light_max_idle_to=240000,light_idle_maintenance_min_budget=60000,light_idle_maintenance_max_budget=180000,min_light_maintenance_time=5000,min_deep_maintenance_time=30000,notification_whitelist_duration=30000
settings put secure pointer_speed 7
cmd package compile -m speed-profile -f com.dts.freefiremax
cmd package compile -m speed-profile -f com.dts.freefireth
setprop debug.hwui.renderer skiagl
setprop debug.gpu.renderer skiagl
setprop debug.angle.overlay FPS:skiagl*PipelineCache*
setprop debug.javafx.animation.framerate 120
setprop debug.systemuicompilerfilter speed
setprop debug.app.performance_restricted false
setprop debug.sf.set_idle_timer_ms 30
setprop debug.sf.disable_backpressure 1
setprop debug.sf.latch_unsignaled 1
setprop debug.sf.enable_hwc_vds 1
setprop debug.sf.showfps 0
setprop debug.sf.showcpu 0
setprop debug.sf.showbackground 0
setprop debug.sf.shoupdates 0
setprop debug.hwui.target_cpu_time_percent 300
setprop debug.hwui.target_gpu_time_percent 300
setprop debug.hwui.use_hint_manager true
setprop debug.multicore.processing 1
setprop debug.fb.rgb565 1
setprop debug.hwui.skip_empty_damage true
setprop debug.qctwa.preservebuf 1
setprop debug.qctwa.preservebuf.comp_level 3
setprop debug.qc.hardware 1
setprop debug.gr.swapinterval 0
setprop debug.sf.swapinterval 0
setprop debug.perf.tuning 1
setprop debug.qcom.hw_hmp.min_fps -1
setprop debug.qcom.hw_hmp.max_fps -1
setprop debug.qcom.pil.q6_boost q
setprop debug.qcom.render_effect 0
setprop debug.adreno.force_rast 1
setprop debug.adreno.prefer_native_sync 1
setprop debug.adreno.q2d_decompress 1
setprop debug.rs.qcom.use_fast_math 1
setprop debug.rs.qcom.disable_expand 1
setprop debug.sf.hw 1
setprop debug.sf.lag_adj 0
setprop debug.sf.showfps 0
setprop debug.hwui.max_frame_time 35.55
setprop debug.sf.disable_backpressure 1
setprop debug.hbm.direct_render_pixmaps 1
setprop debug.hwui.render_compability true
setprop debug.heat_suppression 0
setprop debug.systemuicompilerfilter speed
setprop debug.sensor.hal 0
setprop debug.hwui.render_quality high
setprop debug.sf.gpu_freq_index 7
setprop debug.sf.cpu_freq_index 7
setprop debug.sf.mem_freq_index 7
setprop debug.egl.force_fxaa false
setprop debug.egl.force_taa false
setprop debug.egl.force_msaa false
setprop debug.egl.force_ssaa false
setprop debug.egl.force_smaa false
setprop debug.egl.force_mlaa false
setprop debug.egl.force_txaa false
setprop debug.egl.force_csaa false
setprop debug.hwui.fps_divisor -1
setprop debug.redroid.fps 120
setprop debug.disable_sched_boost true
setprop debug.gpu.cooling.callback_freq_limit false
setprop debug.cpu.cooling.callback_freq_limit false
setprop debug.rs.default-CPU-driver 1
setprop debug.rs.default-CPU-buffer 65536
setprop debug.hwui.use_hint_manager 1
setprop debug.egl.profiler 0
setprop debug.enable.gamed false
setprop debug.qualcomm.sns.daemon 0
setprop debug.qualcomm.sns.libsensor 1
setprop debug.sf.disable_client_composition_cache 1
setprop debug.sf.disable_client_composition_cache 1
setprop debug.sf.disable_hw_vsync true
setprop debug.hwui.disable_vsync true
setprop debug.egl.hw 1
setprop debug.sf.native_mode 1
setprop debug.gralloc.gfx_ubwc_disable 1
setprop debug.video.accelerate.hw 1
cmd power set-adaptive-power-saver-enabled false
cmd power set-fixed-performance-mode-enabled true
cmd power set-mode 0
pm trim-caches 999G
settings put secure multi_press_timeout 400
settings put secure long_press_timeout 400
settings put system pointer_speed 7
settings put system view.scroll_friction 10
 settings put system touch.size.scale 1
 settings put system touch.size.bias 0
 settings put system touch.size.isSummed 0
 settings put system touch.distance.scale 0
 device_config put touchscreen input_drag_min_switch_speed 150
 settings put system touch_drag_and_drop_optimization 1
 settings put system touch_sensitivity_boost 1
 settings put system touch_fling_velocity 20000
 settings put system touch_tap_responsiveness 1
 setprop debug.input.dispatchLatency 0
 setprop debug.input.touch.buffer_size 1024
 setprop debug.input.multi_touch.update_rate 100
 setprop debug.input.touch.buffer_size 256
 setprop debug.input.fast_touch_processing 1
 setprop debug.input.touch.swipe_max_distance 200
 setprop debug.input.touch.wakeup_latency 5
 setprop debug.input.touch.coordinate_precision 0.01
 setprop debug.input.touch.x_sensitivity 1.0
 setprop debug.input.touch.y_sensitivity 1.0
 setprop debug.input.touch.max_tap_time 200
 settings put system touch_pressure_scale 0.001
 settings put system touch_size_calibration geometric
 settings put system touch_size_scale 0.001
 settings put system touch_size_bias 0
 settings put system touch_size_isSummed 0
 settings put system touch_orientation_calibration none
 settings put system touch_distance_calibration none
 settings put system touch_distance_scale 0
 settings put system touch_coverage_calibration box
 settings put system touch_gestureMode spots
 settings put system multitouch_min_distance 1
 settings put system multitouch_settle_interval 1
 settings put system multitouch_min_distance 1
 settings put system multitouch_settle_interval 1
 settings put system vibrate_on_touch 0
 settings put system haptic_feedback_enabled 0
 settings put system MultitouchSettleInterval 0
 settings put system MultitouchMinDistance 0
 settings put system TapInterval 0
 settings put system TapDragInterval 0
 settings put system TapSlop 2527200
 settings put system touch_size.scale 1
 settings put system touch_size.bias 0
 settings put system DragMinSwitchSpeed 2527200
 settings put system SwipeMaxWidthRatio 1
 settings put system MovementSpeedRatio 1
 settings put system ZoomSpeedRatio 1
 settings put system SwipeTransitionAngleCosine 3.6
 settings put system mot_proximity.distance 1
 settings put system tap_interval 1
 settings put system tap_slop 1
dumpsys binder_calls_stats --disable
dumpsys binder_calls_stats --disable-detailed-tracking 
settings put global binder_calls_stats sampling_interval=600000000,detailed_tracking=disable,enabled=false,upload_data=false
settings put secure game_auto_temperature 0
settings put secure game_dashboard_always_on 1
settings put global PERF_RES_FPS_FPSGO_LLF_TH 100
 settings put global PERF_RES_FPS_FPSGO_LLF_POLICY 1
 settings put global PERF_RES_FPS_FPSGO_LLF_LIGHT_LOADING_POLICY 20
 settings put global PERF_RES_FPS_FBT_RESCUE_F 90
 settings put global PERF_RES_FPS_FBT_QR_T2WNT_Y_P 10
 settings put global PERF_RES_FPS_FBT_QR_T2WNT_Y_N 10
 settings put global PERF_RES_FPS_FBT_GCC_ENQ_BOUND_THRS 20
 settings put global PERF_RES_FPS_FBT_GCC_DEQ_BOUND_THRS 20
 settings put global PERF_RES_FPS_FBT_GCC_DEQ_BOUND_QUOTA 6
 settings put global PERF_RES_FPS_FBT_GCC_DOWN_QUOTA_PCT 50
 settings put global PERF_RES_FPS_FPSGO_IDLEPREFER 0
 settings put global PERF_RES_FPS_FPSGO_SPID 1
 settings put global PERF_RES_FPS_GBE1_ENABLE 1
 settings put global PERF_RES_FPS_GBE2_ENABLE 1
 settings put global PERF_RES_FPS_GBE2_TIMER2_MS1 1000
 settings put global PERF_RES_FPS_GBE2_MAX_BOOST_CNT 10
 settings put global PERF_RES_FPS_GBE2_TIMER1_MS 150
 settings put global PERF_RES_FPS_GBE_POLICY_MASK 87
 settings put global PERF_RES_FPS_FBT_CEILING_ENABLE 1
 settings put global PERF_RES_GPU_GED_MARGIN_MODE 110
 settings put global PERF_RES_GPU_FREQ_MAX 100
 settings put global PERF_RES_FPS_FPSGO_BOOST_LR 1
 settings put global PERF_RES_FPS_FBT_ULTRA_RESCUE 1
 settings put global PERF_RES_FPS_FBT_RESCUE_SECOND_GROUP 1
 settings put global PERF_RES_FPS_FBT_RESCUE_SECOND_TIME 1
 settings put global PERF_RES_FPS_FBT_RESCUE_SECOND_ENABLE 1
 settings put global PERF_RES_FPS_FBT_GCC_FPS_MARGIN 120
 cmd game set --fps 120 --mode 2 --downscale 0.8 com.dts.freefiremax
cmd game set --fps 120 --mode 2 --downscale 0.8 com.dts.freefireth
}
game > /dev/null 2>&1  
echo "└───────────────────────┘"
echo "✅ Tối ưu hóa hoàn tất!"
cmd notification post -t "🔥ULTRAGR V2🔥" -S inbox \
    --line "Tăng hiệu suất cao ☑" \
    --line "Ổn định thiết bị, giảm nóng và lag ☑" \
    --line "Tăng nhạy ổn định☑" \
    --line "YouTube: GRAP FIFA 🎮" \
    myTag "Game Gaming" >/dev/null
# Thông tin liên hệ
echo "Vui lòng thoát app"
echo "Test game để trải nghiệm 🎮"
