class_name Player
extends CharacterBody3D

#Nodes
@onready var head = %Head
@onready var eyes = %Eyes
@onready var camera = %MainCamera
@onready var interact_raycast = %InteractRaycast
@onready var viewport = %SubViewportContainer
@onready var crosshair_default = %CrossC
@onready var crosshair_interact = %CrossI

@onready var hand = %Hand

@onready var inventory_component = %InventoryComponent
@onready var equipment_component = %EquipmentComponent
@onready var interact_component = %InteractComponent

@onready var pause_menu = %PauseMenu

# Consts
const BASE_SENS_MULTIPLIER = 0.022
const WALK_SPEED = 2.6
const RUN_SPEED = 4.8
const JUMP_VELOCITY = 7.0
const FRICTION = 12.0

const DEFAULT_CAMERA_FOV = 78.0
const RUN_CAMERA_FOV = 82.0

# Inventory
var inventory: Array[String] = ["paper"]

enum State {
	FREE,
	LOCKED,
	READING,
	FREELOOK
}

# Movement
var is_runnable = false
var is_jumpable = false
var speed = WALK_SPEED
var sensitivity = SettingsManager.sensitivity
var h_sens_mtp = 1.0
var v_sens_mtp = 1.0

var run_transition = 14.0

var current_state := State.FREE

# Wobble
const HEAD_BOBBING_SPEED = 2.8
const HEAD_BOBBING_INTENSITY = 0.022
var head_bobbing_timer = 0.0

# Camera FOV
var start_fov: float
var zoom_fov = 20.0

# Movement vectors
var direction = Vector3.ZERO
var input_dir = Vector2.ZERO

# Backend vars
var h_sens = sensitivity * BASE_SENS_MULTIPLIER * h_sens_mtp
var v_sens = sensitivity * BASE_SENS_MULTIPLIER * v_sens_mtp


func _ready() -> void:
	SettingsManager.change_sensmtp.connect(_on_sensmtp_changed)
	SettingsManager.changed_sensitivity.connect(_on_sensitivity_changed)
	
	SignalManager.add_item.connect(inventory_component.add_item)
	SignalManager.take_item.connect(equipment_component.take_item)
	SignalManager.request_item.connect(equipment_component.put_item)
	SignalManager.trigger_camera_shake.connect(viewport.camera_shake)
	SignalManager.read_note.connect(interact_component._on_read_note)
	_on_sensmtp_changed(ConfigManager.load_settings().screen_mode)
	_on_sensitivity_changed()

func _on_sensmtp_changed(mode):
	if mode != 2:
		var native_res = DisplayServer.screen_get_size()
		var current_window_size = get_window().content_scale_size
		h_sens_mtp = float(native_res.y) / float(current_window_size.y)
		v_sens_mtp = float(native_res.y) / float(current_window_size.y)
	else:
		h_sens_mtp = 1
		v_sens_mtp = 1
	
	h_sens = sensitivity * BASE_SENS_MULTIPLIER * h_sens_mtp
	v_sens = sensitivity * BASE_SENS_MULTIPLIER * v_sens_mtp


func _on_sensitivity_changed():
	sensitivity = SettingsManager.sensitivity
	h_sens = sensitivity * BASE_SENS_MULTIPLIER * h_sens_mtp
	v_sens = sensitivity * BASE_SENS_MULTIPLIER * v_sens_mtp
