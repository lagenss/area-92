extends Component

@onready var interact_status = %InteractStatus


func _process(_delta):
	if p.interact_raycast.is_colliding():
		var obj = p.interact_raycast.get_collider()
		
		var interact_node = _find_interactable(obj)
		
		if interact_node and interact_node.is_interactable:
			
			p.crosshair_interact.visible = true
			interact_status.text = "[E] " + interact_node.prompt_text
			
			if Input.is_action_just_pressed("interact") and p.current_state == p.State.FREE:
				interact_node.interact()
			return
		
	p.crosshair_interact.visible = false
	interact_status.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and p.current_state == p.State.READING:
		%NoteUI.hide()
		p.current_state = p.State.FREE

func _on_read_note(tex: Texture2D):
	$"../../NoteUI/TextureRect".texture = tex
	%NoteUI.show()
	p.current_state = p.State.READING

func _find_interactable(node: Node) -> Interactable:
	if node == null:
		return null
	
	for child in node.get_children():
		if child is Interactable:
			return child
	return null
