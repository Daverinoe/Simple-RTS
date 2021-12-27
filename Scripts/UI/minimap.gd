extends Panel

onready var resolution : Vector2 = OS.get_window_size()

func _ready() -> void:
	self.rect_min_size = $map.texture.get_size()
