extends State

class_name MoveState

var navNode
var target_position : Vector3 = Vector3()
var navPath : Array

var unit
var close_enough : float = 10.0

var speed : int = 50
var direction : Vector3 = Vector3()

func _ready() -> void:
	unit = get_parent()
	animation_player.get_animation("Walk").loop = true
	animation_player.play("Walk")
	
	navNode = LevelVariables.navNode
	
	navPath = get_navPath()


func _physics_process(delta: float) -> void:
	if unit.transform.origin.distance_to(target_position) < close_enough:
		change_state.call_func("idle")
	
	if navPath.size() > 0:
		var destination = navPath[0]
		direction = destination - unit.translation
		
		if unit.translation.distance_to(destination) < close_enough:
			navPath.remove(0)
		
		persistent_state.velocity = direction.normalized() * speed
		
		direction.y = 0
		if direction:
			var look_at_point = unit.translation + direction.normalized()
			unit.look_at(look_at_point, Vector3.UP)
	

func get_navPath() -> Array:
	var path = navNode.get_simple_path(unit.transform.origin, target_position, true)
	print(path)
	return path
