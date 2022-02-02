extends Spatial
tool

export(int, 0, 600) var mapLength : int = 200
export(int, 0, 600) var mapWidth : int = 200
export(int, 0, 10) var mapHeight : int = 5

export(NodePath) onready var mapMeshPath : NodePath
onready var mapMesh = get_node(mapMeshPath)

# Create the Astar node
onready var astar_node = AStar.new()

# The part start and end variables use setter methods
# You can find them at the bottom of the script
var path_start_position = Vector3() setget _set_path_start_position
var path_end_position = Vector3() setget _set_path_end_position

var _point_path = []

const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')

onready var obstacles = _update_obstacles()
onready var _half_cell_size = Vector3(0.5, 0.5, 0.5)


func _ready() -> void:
	mapMesh.mesh.size.x = mapWidth
	mapMesh.mesh.size.y = mapLength
	var collision_box = mapMesh.get_node("StaticBody/CollisionShape")
	collision_box.shape.extents = Vector3(mapLength, 0.1, mapWidth)
	
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)
	


# loops through all cells within the map's bounds and
# adds all points ot the astar_node, except obstacles
func astar_add_walkable_cells(obstacles = []) -> PoolVector3Array:
	var points_array = []
	for z in range(-mapLength/2, mapLength/2):
		for y in range(mapHeight):
			for x in range(-mapWidth/2, mapWidth/2):
				var point = Vector3(x, y, z)
				if point in obstacles:
					continue
				
				points_array.append(point)
				# Want a constant definition of point indices
				var point_index = calculate_point_index(point)
				astar_node.add_point(point_index, point)
	return points_array

# Now we have to connect all our points. 
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell, check all sides (grid-based here, so 6)
		# Current connect point with them
		var points_relative = PoolVector3Array([
			Vector3(point.x + 1, point.y, point.z),
			Vector3(point.x - 1, point.y, point.z),
			Vector3(point.x, point.y + 1, point.z),
			Vector3(point.x, point.y - 1, point.z),
			Vector3(point.x, point.y, point.z + 1),
			Vector3(point.x, point.y, point.z - 1),
		])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)
			
			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			
			astar_node.connect_points(point_index, point_relative_index, false)

func is_outside_map_bounds(point):
	return false


func calculate_point_index(point):
	var px = point.x + ceil(mapWidth/2) + 1
	var pz = point.z + ceil(mapLength/2) + 1
	
	return px + point.y * mapWidth + pz * mapHeight * mapLength


func find_path(start_position, end_position) -> PoolVector3Array:
	self.path_start_position = start_position
	self.path_end_position = end_position
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = point + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path() -> void:
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	# Recalculate the path here
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	$start.translation = _point_path[0]
	$end.translation = _point_path[-1]


func _set_path_start_position(value) -> void:
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return
	
	$start.visible = true
	path_start_position = value
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()

func _set_path_end_position(value) -> void:
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return
	
	$end.visible = true
	path_end_position = value
	if path_start_position != value:
		_recalculate_path()

func _update_obstacles() -> PoolVector3Array:
	return PoolVector3Array()
