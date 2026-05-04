class_name Interactable
extends Node


signal interacted()

@export var prompt_text: String = "Interact"
var is_interactable: bool = true

func interact():
	interacted.emit()
