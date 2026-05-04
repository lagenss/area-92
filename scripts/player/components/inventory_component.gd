extends Component


func add_item(item: String) -> void:
	p.inventory.append(item)

func has_item(item: String) -> bool:
	return p.inventory.has(item)
