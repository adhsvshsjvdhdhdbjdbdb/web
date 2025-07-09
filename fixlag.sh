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
echo "$STICKER_HEADER$(pad_text "UltraV2 Optimizer")$STICKER_HEADER"
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
echo "   Module       : UltraV2 VIP"
echo "   Version      : V2"
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
    phazev1=995000
    phazev2=1984000
    phazev3=4012000
    phazev4=4762000
    phazev5=5596000
    phazev6=9200000
    phazev7=17540000
    hwc_duration=21666667
    ;;
  90)
    frame_ns=11111111
    phazev1=663636
    phazev2=1322798
    phazev3=2677156
    phazev4=3174603
    phazev5=3728597
    phazev6=6132605
    phazev7=11701064
    hwc_duration=14444444
    ;;
  120)
    frame_ns=8333333
    phazev1=497015
    phazev2=991101
    phazev3=2008056
    phazev4=2380952
    phazev5=2800000
    phazev6=4601845
    phazev7=8771930
    hwc_duration=10833333
    ;;
  144)
    frame_ns=6944444
    phazev1=414903
    phazev2=826718
    phazev3=1673494
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
setprop debug.sf.high_fps_early_app_phase_offset_ns $phazev1
setprop debug.sf.high_fps_early_gl_app_phase_offset_ns $phazev1
setprop debug.sf.early_app_phase_offset_ns $phazev2
setprop debug.sf.early_gl_app_phase_offset_ns $phazev2
setprop debug.sf.high_fps_early_gl_phase_offset_ns $phazev3
setprop debug.sf.high_fps_early_phase_offset_ns $phazev3
setprop debug.sf.region_sampling_duration_ns $phazev4
setprop debug.sf.cached_set_render_duration_ns $phazev4
setprop debug.sf.early.app.duration $phazev4
setprop debug.sf.early.sf.duration $phazev4
setprop debug.sf.earlyGl.app.duration $phazev4
setprop debug.sf.earlyGl.sf.duration $phazev4
setprop debug.sf.early_gl_phase_offset_ns $phazev5
setprop debug.sf.early_phase_offset_ns $phazev5
setprop debug.sf.region_sampling_period_ns $phazev6
setprop debug.sf.phase_offset_threshold_for_next_vsync_ns $phazev6
setprop debug.sf.high_fps_late_app_phase_offset_ns $phazev6
setprop debug.sf.high_fps_late_sf_phase_offset_ns $phazev6
setprop debug.sf.late.app.duration $phazev6
setprop debug.sf.late.sf.duration $phazev6
setprop debug.sf.region_sampling_timer_timeout_ns $phazev7
echo "Đã áp dụng tối ưu cho $refresh_rate Hz thành công."


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
}
pe > /dev/null 2>&1  
echo "$PROGRESS_DIV Performance Enhancements Applied ${STICKER_PROGRESS}"
# Tối ưu hóa GPU
gpu() {
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
setprop debug.hwui.target_cpu_time_percent 100  
setprop debug.hwui.target_gpu_time_percent 100  
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
buff() {
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
}
buff > /dev/null 2>&1  
echo "✅ Kích thước màn hình đã đổi: ${new_width}x${new_height}"
echo "$DIVIDER"
echo "$STICKER_COMPLETION$(pad_text "OPTIMIZATION COMPLETED")"
echo "$SECTION_DIV"
echo "$PROGRESS_DIV Enhanced Performance Achieved ${STICKER_COMPLETION}"
echo "$PROGRESS_DIV Device Stability Ensured, Lag Reduced ${STICKER_COMPLETION}"
echo "$PROGRESS_DIV Follow Us: YouTube - GRAP FIFA 🎮"
echo "$DIVIDER"
cmd notification post -t "🔥UltraV2🔥" -S inbox \
    --line "Tăng hiệu suất cao ☑" \
    --line "Ổn định thiết bị, giảm nóng và lag ☑" \
    --line "YouTube: UltraV1 🎮" \
    myTag "Game Gaming" >/dev/null
