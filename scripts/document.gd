extends Node3D

@onready var interact_area = %Interactable

@export var lr_texture: Texture2D
@export var hr_texture: Texture2D

@export var is_read = false

@export var level: Node3D

func _ready() -> void:
	interact_area.interacted.connect(_on_interacted)
	interact_area.prompt_text = "Read"
	level.documents_to_read += 1
	StoryManager.new_stage.connect(_on_new_stage)

	if lr_texture:
		var mat = $document/Plane.get_active_material(0)
		if mat is StandardMaterial3D:
			var unique_mat = mat.duplicate()
			unique_mat.albedo_texture = lr_texture
			$document/Plane.set_surface_override_material(0, unique_mat)

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S4_WORK:
			interact_area.is_interactable = false
		StoryManager.LevelProgress.S5_LEARN_DOCS:
			interact_area.is_interactable = true

func _on_interacted():
	$Sound.play()
	SignalManager.read_note.emit(hr_texture)
	if !is_read:
		level.readen_documents += 1
		if level.readen_documents == level.documents_to_read and level.documents_to_read != 0:
			StoryManager.set_stage(StoryManager.LevelProgress.S6_GET_STARTED)
	is_read = true
