extends Node


var config = ConfigFile.new()
const SAVE_PATH = "user://settings.cfg"

func save_settings(res_w, res_h, sens, s_mode, vol):
	config.set_value("video", "width", res_w)
	config.set_value("video", "height", res_h)
	config.set_value("video", "screen_mode", s_mode)
	config.set_value("input", "sensitivity", sens)
	config.set_value("input", "volume", vol)
	config.save(SAVE_PATH)

func load_settings():
	var err = config.load(SAVE_PATH)
	if err != OK:
		return {
			"width" : 1920,
			"height": 1080,
			"sensitivity": 2.5,
			"screen_mode": 0,
			"volume": 100
		}
	
	var w = config.get_value("video", "width", 1920)
	var h = config.get_value("video", "height", 1080)
	var sm = config.get_value("video", "screen_mode", 0)
	var sens = config.get_value("input", "sensitivity", 2.5)
	var vol = config.get_value("input", "volume", 100)
	
	var export_cfg = {
		"width" : w,
		"height": h,
		"screen_mode": sm,
		"sensitivity": sens,
		"volume": vol
	}
	
	return export_cfg
