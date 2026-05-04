extends Node3D

@onready var alarm_mesh = %alarm_mesh
@onready var alarm_light = %alarm_light


@onready var snd_up = %SndUp
@onready var snd_down = %SndDown

@onready var mat = alarm_mesh.get_active_material(0)

@export var is_alarm: bool = false:
	set(value):
		is_alarm = value
		if is_alarm and not is_pulsing:
			pulse()

var is_pulsing: bool = false

func _on_stop_alarm():
	is_alarm = false

func _ready() -> void:
	if is_alarm:
		pulse()
	SignalManager.triger_alarm.connect(_on_trigger_alarm)
	SignalManager.stop_alarm.connect(_on_stop_alarm)

func _on_trigger_alarm():
	is_alarm = true
	pulse()

func pulse():
	is_pulsing = true
	if not mat: return
	
	var tween = create_tween()
	
	tween.tween_callback(func(): snd_up.play()) 
	tween.tween_property(mat, "emission_energy_multiplier", 1.1, 2.5)
	tween.parallel().tween_property(alarm_light, "light_energy", 16.0, 2.5)
	
	tween.tween_interval(5.4) 
	
	
	tween.tween_callback(func(): snd_down.play())
	tween.tween_property(mat, "emission_energy_multiplier", 0.0, 3.0)
	tween.parallel().tween_property(alarm_light, "light_energy", 0.0, 3.0)
	
	tween.tween_interval(0.81)
	
	tween.finished.connect(func():
		if is_alarm:
			pulse()
		else:
			is_pulsing = false
	)
