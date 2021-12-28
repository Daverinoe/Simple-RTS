extends MarginContainer


func _ready() -> void:
	var margin_value = 8
	add_constant_override("margin_top", margin_value)
	add_constant_override("margin_left", margin_value)
	add_constant_override("margin_bottom", margin_value)
	add_constant_override("margin_right", margin_value)
