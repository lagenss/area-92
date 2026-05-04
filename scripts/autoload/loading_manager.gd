extends Node


# Called when the node enters the scene tree for the first time.
func load_scene(target: String) -> void:
	pass
	var loading_screen = preload("res://scenes/menu/LoadingScreen.tscn").instantiate()
	loading_screen.next_scene_path = target
	get_tree().current_scene.add_child(loading_screen)
