extends Control

var main_menu = "res://scenes/menu/MainMenu.tscn"

var hover_sound = preload("res://assets/sounds/button-hover-click.mp3")
var click_sound = preload("res://assets/sounds/button-click.wav")

@onready var settings_menu = %SettingsMenu
@onready var controls_menu = %ControlsMenu
@onready var escape_menu = $EscapeMenu

@onready var buttons_box = %Buttons
@onready var buttons_sound = %ButtonsSound

@export var ui: CanvasLayer

func _ready() -> void:
	settings_menu.back_pressed.connect(_on_second_closed)
	controls_menu.ok_pressed.connect(_on_second_closed)
	
	for button in buttons_box.get_children():
		if button is TextureButton:
			button.mouse_entered.connect(_play_hover_sound)
			button.pressed.connect(_play_click_sound)
			


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and !get_tree().paused:
		pause()
		escape_menu.visible = true
		settings_menu.visible = false
	elif event.is_action_pressed("ui_cancel") and get_tree().paused:
		if settings_menu.visible or controls_menu.visible:
			escape_menu.visible = true
			settings_menu.visible = false
			controls_menu.visible = false
		else:
			resume()


# Custom functions
func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	ui.visible = false

func resume():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	ui.visible = true


# Buttons
func _on_play_pressed() -> void:
	resume()

func _on_settings_pressed() -> void:
	escape_menu.visible = false
	settings_menu.visible = true


func _on_controls_pressed() -> void:
	escape_menu.visible = false
	controls_menu.visible = true


func _on_menu_pressed() -> void:
	ui.visible = true
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu)

func _on_second_closed():
	escape_menu.visible = true
	settings_menu.visible = false
	controls_menu.visible = false


# Play sound events
func _play_hover_sound():
	buttons_sound.set_stream(hover_sound)
	buttons_sound.play()

func _play_click_sound():
	buttons_sound.set_stream(click_sound)
	buttons_sound.play()
