extends Spatial
tool

export(int, 0, 600) var mapHeight : int = 200
export(int, 0, 600) var mapWidth : int = 200

export(NodePath) onready var mapMeshPath : NodePath
onready var mapMesh = get_node(mapMeshPath)

func _ready() -> void:
	mapMesh.mesh.size.x = mapWidth
	mapMesh.mesh.size.y = mapHeight
	var collision_box = mapMesh.get_node("StaticBody/CollisionShape")
	collision_box.shape.extents = Vector3(mapHeight, 0.1, mapWidth)
	
	LevelVariables.navNode = get_node("Navigation")
