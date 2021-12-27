extends Panel

onready var resolution : Vector2 = OS.get_window_size()

var isPressed : bool = false

func _ready() -> void:
	# Set various sizes
	var sideLength = floor(resolution.x / 6);
	self.rect_min_size = Vector2(sideLength, sideLength)
	
	get_node("mapButton").rect_size = Vector2(sideLength, sideLength)

func _on_mapButton_gui_input(event: InputEvent) -> void:
	print(event)


func _on_mapButton_button_down() -> void:
	print("event")
