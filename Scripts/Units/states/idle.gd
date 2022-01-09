extends State

class_name IdleState

func _ready() -> void:
	animation_player.get_animation("Idle").loop = true
	animation_player.play("Idle")
	persistent_state.velocity = Vector3(0.0, 0.0, 0.0)

