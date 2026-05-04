extends Control

signal ok_pressed

func _on_ok_pressed() -> void:
	ok_pressed.emit()
