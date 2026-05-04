extends CanvasLayer

@export var next_scene_path: String
var warmup_scene_path: String = "res://scenes/compile/GarbageCompiler.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene_path)
	ResourceLoader.load_threaded_request(warmup_scene_path)

func _process(_delta: float) -> void:
	var status_main = ResourceLoader.load_threaded_get_status(next_scene_path)
	var status_warmup = ResourceLoader.load_threaded_get_status(warmup_scene_path)
	
	if status_main == ResourceLoader.THREAD_LOAD_LOADED and status_warmup == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		_start_warmup_and_switch()

func _start_warmup_and_switch() -> void:
	var warmup_scene: PackedScene = ResourceLoader.load_threaded_get(warmup_scene_path)
	var warmup_node = warmup_scene.instantiate()
	add_child(warmup_node)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
	get_tree().change_scene_to_packed(new_scene)
