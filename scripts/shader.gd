extends ColorRect

@onready var svc = %SubViewportContainer

func _ready() -> void:
	SignalManager.panik.connect(_on_panik)

func _on_panik():
	%CrossC.hide()
	$"../../../../../..".current_state = $"../../../../../..".State.FREELOOK
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/contrast", 2.0, 3.36)
	tween.parallel().tween_property(material, "shader_parameter/color_levels", 4.0, 3.36)
	tween.parallel().tween_property(material, "shader_parameter/saturation", 0.0, 3.36)
	tween.parallel().tween_property(material, "shader_parameter/exposure", 0.2, 3.36)
	tween.parallel().tween_property(svc, "modulate", Color(0.0, 0.0, 0.0, 1.0), 4.2)
