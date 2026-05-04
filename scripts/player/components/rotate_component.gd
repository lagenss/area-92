extends Component

func _input(event: InputEvent) -> void:
	# Mouse movement
	if event is InputEventMouseMotion and (p.current_state == p.State.FREE or p.current_state == p.State.FREELOOK):
		p.rotate_y(deg_to_rad(-event.relative.x * p.h_sens))
		p.head.rotate_x(deg_to_rad(-event.relative.y * p.v_sens))
		p.head.rotation.x = clamp(p.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
