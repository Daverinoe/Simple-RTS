extends Control


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("clickSelect"):
		for selected in get_nodes_in_group("Selected"):
			selected.deselect()
