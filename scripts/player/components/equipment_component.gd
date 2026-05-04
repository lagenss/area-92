extends Component



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		if p.inventory_component.has_item("flashlight"):
			print(p.inventory)

func put_item():
	SignalManager.put_item.emit(p.hand)

func take_item(item: Node3D):
	for child in p.hand.get_children():
		p.hand.remove_child(child)
		get_tree().current_scene.add_child(child)
		child.global_transform = item.global_transform
		if child is RigidBody3D:
			child.freeze = false
			child.get_node("CollisionShape3D").disabled = false
			child.position.y += 0.1
			for mesh in child.get_children():
				if mesh is MeshInstance3D:
					mesh.cast_shadow = true
	
	if item.get_parent():
		item.get_parent().remove_child(item)
	
	p.hand.add_child(item)
	
	if item is RigidBody3D:
		item.freeze = true
		item.get_node("CollisionShape3D").disabled = true
		for mesh in item.get_children():
			if mesh is MeshInstance3D:
				mesh.cast_shadow = false
	
	item.transform = Transform3D.IDENTITY
	
