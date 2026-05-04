extends Control

@onready var sens_value = %SensValue
@onready var sens_slider = %SensSlider

@onready var volume_value = %VolumeValue
@onready var volume_slider = %VolumeSlider

@onready var res_value = %ResValue
@onready var screen_mode_value = %ScreenModeValue


signal back_pressed

func _ready() -> void:
	var cfg = ConfigManager.load_settings()
	sens_value.text = str(cfg.sensitivity)
	sens_slider.value = float(cfg.sensitivity)
	screen_mode_value.selected = cfg.screen_mode
	volume_value.text = str(cfg.volume)
	volume_slider.value = float(cfg.volume)
	
	var total_res = str(cfg.width) + "x" + str(cfg.height)
	
	for i in range(res_value.item_count):
		if res_value.get_item_text(i) == total_res:
			res_value.selected = i
			break

# Connect sens between slider and input
func update_sens():
	var temp_value = float(sens_value.text)
	if temp_value == 0.0:
		sens_value.text = str(sens_slider.value)
	elif temp_value < 0.2:
		sens_slider.value = 0.2
		sens_value.text = str(0.2)
	elif temp_value > 20.0:
		sens_slider.value = 20.0
		sens_value.text = str(20.0)
	else:
		sens_slider.value = temp_value

func update_volume():
	var temp_value = int(volume_value.text)
	if temp_value == 0:
		volume_value.text = str(volume_slider.value)
	elif temp_value < 1:
		volume_slider.value = 1
		volume_value.text = str(1)
	elif temp_value > 100:
		volume_slider.value = 100
		volume_value.text = str(100)
	else:
		volume_slider.value = temp_value

# Buttons logic
func _on_back_pressed() -> void:
	back_pressed.emit()

func _on_apply_pressed() -> void:
	var res = res_value.get_item_text(res_value.selected)
	var width = int(res.split("x")[0])
	var height = int(res.split("x")[1])
	var screenmode = screen_mode_value.selected
	SettingsManager.change_res(width, height, screenmode)
	SettingsManager.change_sensitivity(float(sens_value.text))
	SettingsManager.change_volume(int(volume_value.text))
	ConfigManager.save_settings(width, height, float(sens_value.text), screenmode, int(volume_value.text))

func _on_sens_slider_value_changed(value: float) -> void:
	sens_value.text = str(snapped(value, 0.01))

func _on_sens_value_text_submitted(_new_text: String) -> void:
	update_sens()

func _on_sens_value_focus_exited() -> void:
	update_sens()



func _on_volume_slider_value_changed(value: float) -> void:
	volume_value.text = str(snapped(value, 1))

func _on_volume_value_text_submitted(_new_text: String) -> void:
	update_volume()

func _on_volume_value_focus_exited() -> void:
	update_volume()
