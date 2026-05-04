extends Component

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not p.is_on_floor():
		p.velocity += p.get_gravity() * delta
		
	# Handle jump.
	if p.current_state == p.State.FREE:
		if Input.is_action_just_pressed("ui_accept") and p.is_jumpable and p.is_on_floor():
			p.velocity.y = p.JUMP_VELOCITY
			
		if Input.is_action_pressed("speed") and p.is_runnable and p.input_dir != Vector2.ZERO and p.velocity != Vector3.ZERO:
			p.speed = p.RUN_SPEED
			p.camera.fov = lerp(p.camera.fov, p.RUN_CAMERA_FOV, delta * p.run_transition)
		else:
			p.speed = p.WALK_SPEED
			p.camera.fov = lerp(p.camera.fov, p.DEFAULT_CAMERA_FOV, delta * p.run_transition)
		
		# Get the input direction and handle the movement/deceleration.
		p.input_dir = Input.get_vector("left", "right", "forward", "back")
		p.direction = lerp(p.direction, (p.transform.basis * Vector3(p.input_dir.x, 0, p.input_dir.y)).normalized(), delta * p.FRICTION)
		if p.direction:
			p.velocity.x = p.direction.x * p.speed
			p.velocity.z = p.direction.z * p.speed
		else:
			p.velocity.x = move_toward(p.velocity.x, 0, p.speed)
			p.velocity.z = move_toward(p.velocity.z, 0, p.speed)
	else:
		p.direction = Vector3.ZERO
		p.input_dir = Vector2.ZERO
		p.velocity.x = lerp(p.velocity.x, 0.0, delta * p.FRICTION)
		p.velocity.z = lerp(p.velocity.z, 0.0, delta * p.FRICTION)
	
	p.move_and_slide()
	
	# Push rigidbodies
	for i in p.get_slide_collision_count():
		var collision = p.get_slide_collision(i)
		var collider = collision.get_collider()
	
		if collider is RigidBody3D:
			var push_dir = -collision.get_normal()
			push_dir.y = 0
			collider.apply_central_impulse(push_dir * 1.5)
