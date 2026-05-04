extends RigidBody3D

@onready var interact_area = %Interactable
@onready var liquid_mesh = %liquid_green
@onready var body = %body
var identify = "green_capsule"

var can_request_next_capsule = true

@export var capacity = 100.0

func _ready() -> void:
		interact_area.interacted.connect(_on_interacted)
		liquid_mesh.scale.y = capacity / 100.0
		StoryManager.new_stage.connect(_on_new_stage)
		interact_area.prompt_text = "Take"

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S4_WORK:
			interact_area.is_interactable = false
		StoryManager.LevelProgress.S6_GET_STARTED:
			interact_area.is_interactable = true

func _on_interacted():
	SignalManager.take_item.emit(self)
