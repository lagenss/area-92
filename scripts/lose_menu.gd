extends Control

var roll_speed = 128

@onready var content = $HBoxContainer

@onready var menu = $Label

var time_passed = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	content.position.y -= roll_speed * delta
	time_passed += delta
	
	if time_passed >= 8.5:
		menu.show()
	
	if time_passed >= 25:
		get_tree().quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		LoadingManager.load_scene("res://scenes/menu/MainMenu.tscn")
	if event.is_action_pressed("retry"):
		LoadingManager.load_scene("res://scenes/Office.tscn")
