extends Panel

onready var resolution : Vector2 = OS.get_window_size()

var isPressed : bool = false

export(NodePath) onready var levelPath : NodePath
onready var level = get_node(levelPath)

signal minimap_clicked(clickPosition)

onready var sideLength = floor(resolution.x / 6);

func _ready() -> void:
	# Set various sizes
	self.rect_min_size = Vector2(sideLength, sideLength)
	
	get_node("mapButton").rect_size = Vector2(sideLength, sideLength)
	set_texture()


func set_texture() -> void:
	var levelTexture = level.get_node("MeshInstance").get_active_material(0).albedo_texture
	get_node("mapButton").texture_normal = levelTexture


func _on_mapButton_gui_input(event: InputEvent) -> void:
	if Input.is_action_pressed("clickSelect"):
		emit_signal("minimap_clicked", _createMapping(get_node("mapButton").rect_position, event.position))

func _createMapping(mapPosition : Vector2, input : Vector2) -> Vector2:
	var miniX = Vector2(mapPosition.x, mapPosition.x + sideLength)
	var miniY = Vector2(mapPosition.y, mapPosition.y + sideLength)
	
	var levelX = Vector2(-level.mapHeight/2, level.mapHeight/2)
	var levelY = Vector2(-level.mapWidth/2, level.mapWidth/2)
	
	var xSlope = 1.0 * (levelX.y - levelX.x) / (miniX.y - miniX.x)
	var xOut = levelX.x + xSlope * (input.x - miniX.x)
	
	var ySlope = 1.0 * (levelY.y - levelY.x) / (miniY.y - miniY.x)
	var yOut = levelY.x + ySlope * (input.y - miniY.x)
	
	return Vector2(xOut, yOut)
