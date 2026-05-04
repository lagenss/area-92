extends Node3D

@export var valve: Node3D
@export var machine: Node3D

@onready var text_blocks = %Text

@onready var pressure = %Value
@onready var green = %A
@onready var yellow = %B
@onready var blue = %C



func _process(delta: float) -> void:
	if machine.is_launched:
		var p_text = "%.1f" % valve.psi
		var g_text = "%.1f" % machine.liquid_levels["green"]
		var y_text = "%.1f" % machine.liquid_levels["yellow"]
		var b_text = "%.1f" % machine.liquid_levels["blue"]
		if machine.ok_status:
			text_blocks.show()
			pressure.text = "> " + p_text + " PSI"
			green.text = "> A: " + g_text + " %"
			yellow.text = "> B: " + y_text + " %"
			blue.text = "> C: " + b_text + " %"
		else:
			pressure.text = "> " + "ERR" + " PSI"
			green.text = "> A: " + "ERR" + " %"
			yellow.text = "> B: " + "ERR" + " %"
			blue.text = "> C: " + "ERR" + " %"
