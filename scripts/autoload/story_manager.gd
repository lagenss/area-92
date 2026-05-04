extends Node

signal new_stage(st: LevelProgress)

enum LevelProgress{
	S1_BEGIN,
	S2_DOCUMENTS,
	S2_5_DOCUMENTS_CHECKED,
	S3_DOCUMENTS_PASSED,
	S4_WORK,
	S5_LEARN_DOCS,
	S6_GET_STARTED,
	S7_UNLOCK_LEVER,
	S8_START_MACHINE,
	
	PREWIN = 200,
	BUTTON_AWAIT = 201,
	WIN = 202,
	
	LOSE = 400,
}

var is_won = false


var current_stage: LevelProgress
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_stage(stage: LevelProgress):
	current_stage = stage
	print(stage)
	new_stage.emit(stage)
	
