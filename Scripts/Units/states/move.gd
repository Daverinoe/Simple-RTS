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
	


func _physics_process(delta: float) -> void:
	if unit.translation.distance_to(unit.target_position) < close_enough:
		change_state.call_func("idle")
	
