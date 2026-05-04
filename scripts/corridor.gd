extends Node3D

var ease_speed = 1.0

@export var player: Player

func _ready() -> void:
	StoryManager.set_stage(StoryManager.LevelProgress.S1_BEGIN)
	player.crosshair_default.hide()
	player.current_state = player.State.FREELOOK
	player.viewport.modulate = Color(0, 0, 0, 1)
	
	var fade_tween = create_tween()
	fade_tween.tween_interval(0.3)
	fade_tween.tween_property(player.viewport, "modulate", Color(1.0, 1.0, 1.0, 1.0), ease_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_tween.finished.connect(_on_intro_finished)

func _on_intro_finished() -> void:
	player.crosshair_default.show()
	player.current_state = player.State.FREE
