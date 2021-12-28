extends Spatial

export(int, 0, 600) var mapHeight : int = 200
export(int, 0, 600) var mapWidth : int = 200

export(NodePath) onready var mapMeshPath : NodePath
onready var mapMesh = get_node(mapMeshPath)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mapMesh.mesh.size.x = mapWidth
	mapMesh.mesh.size.y = mapHeight
