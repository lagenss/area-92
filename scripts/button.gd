extends StaticBody3D

@onready var interact_area: Interactable = %Interactable
@export var available: bool = true

func _ready():
	interact_area.interacted.connect(_on_interacted)
	SignalManager.add_item.connect(_on_interacted)
	interact_area.is_interactable = available
	interact_area.prompt_text = "Press Button"

func _on_interacted():
	pass
