extends Node3D

@onready var interact_area = %Interactable
@onready var valve_mesh = %valve_mesh
@export var machine: Node3D

const CRITICAL_PSI_MAX = 850
const CRITICAL_PSI_MIN = 450

const WARNING_PSI_MAX = 800
const WARNING_PSI_MIN = 550

var critical_psi_leak = 852.2

var psi_leak = 12.5
var psi_pump = 24.2

var psi = 750

var is_lost = false

func _ready() -> void:
	interact_area.interacted.connect(_on_interacted)
	interact_area.is_interactable = false
	StoryManager.new_stage.connect(_on_new_stage)
	interact_area.prompt_text = "Turn"

func _on_new_stage(stage):
	match stage:
		StoryManager.LevelProgress.S8_START_MACHINE:
			interact_area.is_interactable = true

func _on_interacted():
	psi += psi_pump
	var tween = create_tween()
	tween.tween_property(valve_mesh, "rotation:z", valve_mesh.rotation.z + deg_to_rad(-15), 0.1)
	

func _physics_process(delta: float) -> void:
	if machine.is_launched:
		if machine.ok_status:
			psi -= psi_leak * delta
		else:
			psi -= critical_psi_leak * delta
	if psi >= 850 or psi <= 450:
		machine.break_machine()
		set_physics_process(false)
		is_lost = true
		machine.interact_area.is_interactable = false
		SignalManager.triger_alarm.emit()
		if (machine.liquid_levels["green"] * machine.liquid_levels["blue"] * machine.liquid_levels["yellow"]) > 0:
			StoryManager.is_won = false
			StoryManager.set_stage(StoryManager.LevelProgress.LOSE)
			
