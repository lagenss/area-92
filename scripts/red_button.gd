extends Node3D

@onready var interact_area = %Interactable

@onready var explosion = %Explosion
@onready var boom_snd = %Boom

@onready var button_mesh = $redbtn/Sketchfab_model/Buttons_Cyrcle_1_fbx/RootNode/Button_Cyrcle_1_Button/Button_Cyrcle_1_Button_Button_Cyrcle_1_0

@export var player: Player

var is_forced = false
var real_win = false

func _ready() -> void:
	interact_area.interacted.connect(_on_interacted)
	interact_area.prompt_text = "Press"
	StoryManager.new_stage.connect(_on_new_stage)

func boom():
	var light_tween = create_tween()
	light_tween.tween_property(explosion, "light_energy", 128000, 0.3)
	button_mesh.hide()
	SignalManager.trigger_camera_shake.emit(240.0, 1.2)
	interact_area.is_interactable = false
	boom_snd.play()
	await get_tree().create_timer(0.3).timeout
	LoadingManager.load_scene("res://scenes/LoseMenu.tscn")

func button_await():
	await get_tree().create_timer(5).timeout
	if real_win:
		StoryManager.set_stage(StoryManager.LevelProgress.WIN)
	else:
		StoryManager.set_stage(StoryManager.LevelProgress.LOSE)

func save():
	SignalManager.stop_alarm.emit()
	$AnimationPlayer.play("pressbtn")
	$AudioStreamPlayer3D.play()
	real_win = true

func _on_interacted():
	if is_forced:
		save()
	else:
		boom()

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.BUTTON_AWAIT:
			is_forced = true
			button_await()
		StoryManager.LevelProgress.WIN:
			print("YOU WON!")
func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
