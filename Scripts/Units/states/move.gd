extends State

class_name MoveState

var navPath : PoolVector3Array

var unit
var close_enough : float = 10.0

var speed : int = 50
var direction : Vector3 = Vector3()

func _ready() -> void:
	unit = get_parent()
	animation_player.get_animation("Walk").loop = true
	animation_player.play("Walk")
	
	var level = get_tree().get_root().get_node("game/level")
	
	var path_start = Vector3(round(unit.translation.x), round(unit.translation.y), round(unit.translation.z))
	var path_end = Vector3(round(unit.target_position.x), round(unit.target_position.y), round(unit.target_position.z))
	navPath = level.find_path(path_start, path_end)
	
	print(navPath)


func _physics_process(delta: float) -> void:
	if unit.translation.distance_to(unit.target_position) < close_enough:
		change_state.call_func("idle")
	
