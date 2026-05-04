extends Node3D

@onready var interact_area = %Interactable

@onready var handle = $lever/StaticBody3D/lever_etx_2/lever_etx_2_child

@export var machine: Node3D

func _ready() -> void:
	interact_area.interacted.connect(_on_interacted)
	interact_area.is_interactable = false
	StoryManager.new_stage.connect(_on_new_stage)
	interact_area.prompt_text = "Launch"

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S6_GET_STARTED:
			interact_area.is_interactable = true

func _on_interacted():
	var tween = create_tween()
	if machine.insert_counter == 3:
		tween.tween_property(handle, "rotation_degrees", Vector3(90, 0, 0), 0.67).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		interact_area.is_interactable = false
		%LeverSound.play()
		machine.launch()
		SignalManager.trigger_camera_shake.emit(60, 0.25)
		StoryManager.set_stage(StoryManager.LevelProgress.S8_START_MACHINE)
	else:
		tween.tween_property(handle, "rotation_degrees", Vector3(15, 0, 0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(handle, "rotation_degrees", Vector3(0, 0, 0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
