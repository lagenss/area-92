extends Node


signal add_item(item: String)
signal wrong_way
signal take_item(item: Node3D)
signal put_item(item: Node3D)
signal request_item
signal triger_alarm
signal trigger_camera_shake(strength: float, duration: float)
signal capsule_stuck
signal stop_alarm

signal panik


signal request_capsule(type: String)

signal read_note(note: Texture2D)

signal speak(text: String)
