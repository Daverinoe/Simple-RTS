extends Spatial
class_name StaticSelectable

var selected : bool = false

export(StreamTexture) var portrait : StreamTexture = load("res://Assets/Textures/icon.png")

func _ready() -> void:
	if (is_in_group("Owned")):
		$reticle.modulate = Color(0.0, 0.0, 1.0, 1.0)

func select() -> void:
	if selected:
		deselect()
	else:
		selected = true
		$reticle.visible = true
		add_to_group("Selected")
		SignalBus.emit_signal("objectSelected", self)

func deselect() -> void:
	selected = false
	$reticle.visible = false
	remove_from_group("Selected")
	SignalBus.emit_signal("objectDeselected", self)
