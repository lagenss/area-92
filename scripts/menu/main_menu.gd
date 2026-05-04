extends Control

var main_scene = "res://scenes/Corridor.tscn"

var hover_sound = preload("res://assets/sounds/button-hover-click.mp3")
var click_sound = preload("res://assets/sounds/button-click.wav")

@onready var main_menu = %MenuBody
@onready var settings_menu = %SettingsMenu
@onready var controls_menu = %ControlsMenu
@onready var main_menu_panel = %MainMenuPanel

@onready var buttons_box = %MainMenuButtons
@onready var buttons_sound = %ButtonsSound

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	settings_menu.back_pressed.connect(_on_settings_closed)
	controls_menu.ok_pressed.connect(_on_control_closed)
	$Noise.play()
	
	for button in buttons_box.get_children():
		if button is TextureButton:
			button.mouse_entered.connect(_play_hover_sound)
			button.pressed.connect(_play_click_sound)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and (settings_menu.visible or controls_menu.visible):
		_on_settings_closed()
		_on_control_closed()

# Buttons events
func _on_play_button_pressed() -> void:
	LoadingManager.load_scene(main_scene)

func _on_settings_button_pressed() -> void:
	main_menu.visible = false
	main_menu_panel.visible = false
	settings_menu.visible = true

func _on_controls_button_pressed() -> void:
	main_menu.visible = false
	main_menu_panel.visible = false
	controls_menu.visible = true

func _on_exit_button_pressed() -> void:
	get_tree().quit()


# External events
func _on_settings_closed():
	main_menu.visible = true
	main_menu_panel.visible = true
	settings_menu.visible = false

func _on_control_closed():
	main_menu.visible = true
	main_menu_panel.visible = true
	controls_menu.visible = false


# Play sound events
func _play_hover_sound():
	buttons_sound.set_stream(hover_sound)
	buttons_sound.play()

func _play_click_sound():
	buttons_sound.set_stream(click_sound)
	buttons_sound.play()
