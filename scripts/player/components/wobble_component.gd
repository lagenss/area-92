extends Component

var lean_speed = 5.0
var lean_amount = 0.5

func _physics_process(delta: float) -> void:
	# Horizontal velo
	var horizontal_velo = Vector2(p.velocity.x, p.velocity.z).length()

	# Camera lean
	var input_x = p.input_dir.x * abs(p.input_dir.x)
	var target_roll = -input_x * horizontal_velo * lean_amount
	p.eyes.rotation_degrees.z = lerp(p.eyes.rotation_degrees.z, target_roll, lean_speed * delta)

	# Camera wobble
	if p.is_on_floor() and horizontal_velo > 1.4:
		p.head_bobbing_timer += delta * horizontal_velo
		var bob_y = sin(p.head_bobbing_timer * p.HEAD_BOBBING_SPEED) * p.HEAD_BOBBING_INTENSITY  * (1 + (horizontal_velo * 0.1)) 
	
		p.eyes.transform.origin = Vector3(0, bob_y, 0)
	else:
		p.head_bobbing_timer = 0
		p.eyes.transform.origin = lerp(p.eyes.transform.origin, Vector3.ZERO, delta * 10)
