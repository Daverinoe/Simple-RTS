extends PersistentState


func _ready() -> void:
	$worker_M/AnimationPlayer.get_animation("Idle").loop = true
	$worker_M/AnimationPlayer.play("Idle")
