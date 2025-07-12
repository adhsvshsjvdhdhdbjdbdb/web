#!/system/bin/sh
echo "Module khôi phục"
sleep 1
echo "Bắt đầu khôi phục lại trạng thái Bình thường của máy"
reset() {
settings delete global activity_manager_constants 
settings delete system POWER_BALANCED_MODE_OPEN 
settings delete system POWER_PERFORMANCE_MODE_OPEN 
settings delete system POWER_SAVE_MODE_OPEN 
settings delete system POWER_SAVE_PRE_CLEAN_MEMORY_TIME 
settings delete system POWER_SAVE_PRE_HIDE_MODE performance
settings delete system POWER_SAVE_PRE_SYNCHRONIZE_ENABLE 
settings delete global GPUTUNER_SWITCH 
settings delete global CPUTUNER_SWITCH 
settings delete global performance_profile 
cmd power set-fixed-performance-mode-enabled false
device_config delete activity_manager fgs_start_allowed_log_sample_rate 
device_config delete activity_manager fgs_start_denied_log_sample_rate 
settings delete system ro.min.fling_velocity 
settings delete system ro.max.fling_velocity 
settings delete system speed_pointer
settings delete system game-touchscreen-boost 
settings delete system touch.pressure.scale 
settings delete system touch_boost 
settings delete system ram_boost
settings delete global touch_drag_and_drop_optimization 
settings delete global touch_sensitivity_boost 
settings delete global touch_tap_responsiveness 
settings delete system touch_latency     
settings delete secure touch_resampling_rate 
settings delete system min_touch_target 
settings delete global touch_response_time 
settings delete global touch_fling_velocity 
settings delete global fling_velocity    
settings delete system screen_brightness_mode 
settings delete system touch_delay 
settings delete system haptic_feedback_enabled 
device_config delete touchscreen input_drag_min_switch_speed 
device_config delete systemui min_fling_velocity 
device_config delete systemui max_fling_velocity 
device_config delete input touch_screen_sample_interval_ms 
settings delete system touch.size.calibration 
settings delete system touch.pressure.calibration 
settings put global window_animation_scale 1
settings put global transition_animation_scale 1
settings put global animator_duration_scale 1
cmd power set-adaptive-power-saver-enabled true
cmd power set-fixed-performance-mode-enabled false
cmd power set-mode 1
dumpsys battery reset
}
reset > /dev/null 2>&1  
echo "Khôi phục buff màn hình"
wm size reset
wm density reset    
echo "Thành công☑"
echo "Cảm ơn ae đã sử dụng"
echo "Ủng hộ tôi = Đăng ký kênh youtube : GRAP FIFA"
echo "Tik Tok: GRAP FIFA nhé😋"
echo "Vui lòng thoát app👌"
