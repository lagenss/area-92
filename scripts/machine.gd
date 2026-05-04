extends Node3D

@onready var interact_area = %Interactable

@export var crate: Node3D

@onready var green_slot = %GreenSlot
@onready var yellow_slot = %YellowSlot
@onready var blue_slot = %BlueSlot

@onready var work_snd = preload("res://assets/sounds/machine_work.mp3")
@onready var stop_snd = preload("res://assets/sounds/machine_stop.mp3")
@onready var launch_snd = preload("res://assets/sounds/machine_launch.mp3")

var is_alarm = false
var is_launched = false
var ok_status = true
var prev_status = true

var liquid_levels = {
	"green": 1,
	"blue": 1,
	"yellow": 1
}

var autorequest_capacity = 12.0

var insert_counter = 0

func _ready() -> void:
		interact_area.interacted.connect(_on_interacted)
		SignalManager.put_item.connect(_on_put_item)

func eat_liquid(slot, speed: float, dt, type: String):
	var liquid = slot.get_child(0)
	liquid_levels[type] = liquid.capacity
	if liquid.liquid_mesh.scale.y > 0:
		liquid.capacity -= speed * dt
		liquid.liquid_mesh.scale.y = liquid.capacity / 100.0
		if liquid.capacity < autorequest_capacity and liquid.can_request_next_capsule:
			SignalManager.request_capsule.emit(type)
			liquid.can_request_next_capsule = false
			pass


func _physics_process(delta: float) -> void:
	if insert_counter == 3 and is_launched and ok_status:
		eat_liquid(green_slot, 3, delta, "green")
		eat_liquid(yellow_slot, 4.6, delta, "yellow")
		eat_liquid(blue_slot, 2.4, delta, "blue")
	if (liquid_levels["green"] * liquid_levels["blue"] * liquid_levels["yellow"]) > 0:
		ok_status = true
		if !prev_status:
			launch()
	else:
		if ok_status:
			%Noise.stop()
			%Noise.stream = stop_snd
			%Noise.play()
			ok_status = false
	prev_status = ok_status

func insert_capsule(slot: Marker3D, item: Node3D, levels: Dictionary, strng: String):
	if slot.get_child_count() > 0:
		var old_capsule = slot.get_child(0)
		
		var moved = false
		for slotik in crate.get_children():
			if slotik is Marker3D and slotik.get_child_count() == 0:
				slot.remove_child(old_capsule)
				slotik.add_child(old_capsule)
				old_capsule.freeze = false
				old_capsule.get_node("CollisionShape3D").disabled = false
				old_capsule.transform = Transform3D.IDENTITY
				old_capsule.interact_area.is_interactable = false
				insert_counter -= 1
				moved = true
				break
		
		if not moved:
			return
	levels[strng] = item.capacity
	if item.get_parent():
		item.get_parent().remove_child(item)
	
	item.liquid_mesh.cast_shadow = true
	item.body.cast_shadow = true
	item.transform = Transform3D.IDENTITY
	slot.add_child(item)
	insert_counter += 1
	if insert_counter == 3 and !is_launched:
		StoryManager.set_stage(StoryManager.LevelProgress.S7_UNLOCK_LEVER)

func _on_put_item(hands):
	for item in hands.get_children():
		if item.get_parent():
			item.get_parent().remove_child(item)
		if item and "identify" in item:
			%Clicks.play()
			match item.identify:
				"blue_capsule":
					insert_capsule(blue_slot, item, liquid_levels, "blue")
				"yellow_capsule":
					insert_capsule(yellow_slot, item, liquid_levels, "yellow")
				"green_capsule":
					insert_capsule(green_slot, item, liquid_levels, "green")

func launch():
	%Noise.stream = launch_snd
	%Noise.play()
	await get_tree().create_timer(4.3).timeout
	is_launched = true
	await %Noise.finished
	%Noise.stream = work_snd
	%Noise.play()

func _on_interacted():
	SignalManager.request_item.emit()

func break_machine():
	%Noise.stop()
	%Noise.stream = stop_snd
	%Noise.play()
	ok_status = false
	is_launched = false
	if StoryManager.is_won:
		StoryManager.set_stage(StoryManager.LevelProgress.PREWIN)
	else:
		StoryManager.set_stage(StoryManager.LevelProgress.LOSE)
