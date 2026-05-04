extends Node
class_name Component

@onready var p: Player

func _ready():
	var current_node = get_parent()
	
	while current_node != null:
		if current_node is Player:
			p = current_node
			break
		current_node = current_node.get_parent()
	
	if not p:
		push_error("Component: Couldn't find Player")
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
