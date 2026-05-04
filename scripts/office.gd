extends Node3D

var ease_speed = 0.6

@export var player: Player

var documents_to_read: int = 0
var readen_documents: int = 0

func _ready() -> void:
	get_tree().paused = false
	player.current_state = player.State.FREELOOK
	player.viewport.modulate = Color(0, 0, 0, 1)
	
	var fade_tween = create_tween()
	fade_tween.tween_property(player.viewport, "modulate", Color(1.0, 1.0, 1.0, 1.0), ease_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_tween.finished.connect(_on_intro_finished)

func _on_intro_finished() -> void:
	player.current_state = player.State.FREE
	await get_tree().create_timer(0.4).timeout
	StoryManager.set_stage(StoryManager.LevelProgress.S4_WORK)
