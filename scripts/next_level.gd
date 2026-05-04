extends Node3D

@onready var interact_area = %Interactable
@export var player: CharacterBody3D

func _ready() -> void:
	interact_area.interacted.connect(_on_interacted)
	interact_area.prompt_text = "Enter"
	StoryManager.new_stage.connect(_on_new_stage)
	interact_area.is_interactable = false
	
func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S3_DOCUMENTS_PASSED:
			interact_area.is_interactable = true

func _on_interacted():
	interact_area.is_interactable = false
	player.viewport.modulate = Color(1, 1, 1, 1.0)
	var fade_tween = create_tween()
	fade_tween.tween_property(player.viewport, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_tween.finished.connect(_on_next_level)
	
func _on_next_level() -> void:
	LoadingManager.load_scene("res://scenes/Office.tscn")
