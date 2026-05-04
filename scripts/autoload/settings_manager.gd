extends Node

var sensitivity = 4.2

signal change_sensmtp(is_windowed)

signal changed_sensitivity()

var native_res = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	var cfg = ConfigManager.load_settings()
	change_res(cfg.width, cfg.height, cfg.screen_mode)
	change_sensitivity(cfg.sensitivity)
	change_volume(cfg.volume)

	

func change_sensitivity(s: float):
	sensitivity = s
	changed_sensitivity.emit()

func center_window():
	var screen = DisplayServer.window_get_current_screen()
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var window_size = DisplayServer.window_get_size()
	var center_pos = screen_rect.position + (screen_rect.size / 2) - (window_size / 2)
	
	DisplayServer.window_set_position(center_pos)

func change_res(w: int, h: int, mode_index: int):
	match mode_index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			get_tree().root.content_scale_size = Vector2i(w, h)
			
		1: # Fullscreen Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			get_tree().root.content_scale_size = Vector2i(w, h)
			DisplayServer.window_set_size(native_res)
			DisplayServer.window_set_position(Vector2i(0, 0))
			
		2: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			get_tree().root.content_scale_size = Vector2i(w, h)
			DisplayServer.window_set_size(Vector2i(w, h))
			center_window()
			
	change_sensmtp.emit(mode_index)

func change_volume(vol):
	var volume = float(vol) / 100.0
	AudioServer.set_bus_volume_db(0, linear_to_db(volume))
	AudioServer.set_bus_mute(0, volume < 0.01)
