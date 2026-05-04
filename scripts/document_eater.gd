extends Node3D

@onready var interact_area = %Interactable
@onready var sound = $AudioStreamPlayer3D

func _ready() -> void:
	interact_area.interacted.connect(_on_interacted)
	interact_area.prompt_text = "Put Papers"
	interact_area.is_interactable = false
	
	StoryManager.new_stage.connect(_on_new_stage)

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S2_DOCUMENTS:
			await get_tree().create_timer(3.0).timeout
			interact_area.is_interactable = true


func _on_interacted():
	sound.play()
	interact_area.is_interactable = false
	%AnimationPlayer.play("give_document")
	await %AnimationPlayer.animation_finished
	StoryManager.set_stage(StoryManager.LevelProgress.S2_5_DOCUMENTS_CHECKED)
