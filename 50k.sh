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
  cmd device_config put game_overlay "$package" mode=2,fps=120,useAngle=true
done
}
game > /dev/null 2>&1  
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
echo "Success☑️" 
echo "Vui lòng không khởi động lại máy sẽ mất tác dụng"
echo "Vào game test thôi🎮"
cmd notification post -t "🔥ZERO V2🔥" -S inbox \
    --line "Tăng hiệu suất cao ☑" \
    --line "Ổn định thiết bị, giảm nóng và lag ☑" \
    --line "Tăng nhạy ổn định☑" \
    --line "YouTube: GRAP FIFA 🎮" \
    myTag "Game Gaming" >/dev/null
