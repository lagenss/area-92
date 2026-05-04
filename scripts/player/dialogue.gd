extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0.0
	SignalManager.speak.connect(_update_text)

func _update_text(new_text: String):
	visible_ratio = 0.0
	text = new_text
	
	var duration = new_text.length() * 0.01
	
	var text_tween = create_tween()
	text_tween.tween_property(self, "visible_ratio", 1.0, duration)
