extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StoryManager.new_stage.connect(_on_new_stage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S3_DOCUMENTS_PASSED:
			pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		StoryManager.set_stage(StoryManager.LevelProgress.S2_DOCUMENTS)
		$Area3D.queue_free()


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body is Player:
		match StoryManager.current_stage:
			StoryManager.LevelProgress.S3_DOCUMENTS_PASSED:
				SignalManager.wrong_way.emit()
				$Area3D2.queue_free()
