
class_name StateFactory

var states

func _init() -> void:
	states = {
		"idle": IdleState,
		"move": MoveState,
		"attack": AttackState
	}

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	printerr("No state ", state_name, " in state factory!")
