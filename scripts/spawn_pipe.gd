extends Node3D

@onready var blue_capsule = preload("res://prefabs/BlueCapsule.tscn")
@onready var yellow_capsule = preload("res://prefabs/YellowCapsule.tscn")
@onready var green_capsule = preload("res://prefabs/GreenCapsule.tscn")

@onready var broken_capsule = preload("res://prefabs/static/BrokenCapsule.tscn")

@onready var marker = %Marker3D

var requested_capsules = 0
var max_reqs = 4

var ok_status = true

func _ready() -> void:
	SignalManager.request_capsule.connect(_on_spawn_object)

func spawn_object(cpsl):
	if cpsl:
		if requested_capsules < max_reqs:
			var new_capsule = cpsl.instantiate()
			marker.add_child(new_capsule)
			requested_capsules += 1
			if requested_capsules == max_reqs:
				await get_tree().create_timer(1.2).timeout
				SignalManager.capsule_stuck.emit()
		else:
			ok_status = false
			var capsul = broken_capsule.instantiate()
			%Glass.play()
			marker.add_child(capsul)
			StoryManager.is_won = true
			await get_tree().create_timer(1.2).timeout
			SignalManager.trigger_camera_shake.emit(16.0, 0.2)

func _on_spawn_object(type):
	if ok_status:
		%Pneumo.play()
		await get_tree().create_timer(0.3).timeout
		match type:
			"blue":
				spawn_object(blue_capsule)
			"yellow":
				spawn_object(yellow_capsule)
			"green":
				spawn_object(green_capsule)
