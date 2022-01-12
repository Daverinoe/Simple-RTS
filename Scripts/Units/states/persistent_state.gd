extends selectableUnit

class_name PersistentState

onready var level = get_tree().get_root().get_node("game/level")

var state
var state_factory : StateFactory
var target_position : Vector3

# Public variables
var velocity : Vector3 = Vector3()

# Private variables (settable)
export var health : int = 50


func _ready() -> void:
	state_factory = StateFactory.new()
	change_state("idle")


func change_state(new_state):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state).new()
	state.setup(funcref(self, "change_state"), $baseModel/AnimationPlayer, self)
	state.name = "current_state"
	add_child(state)


func rightClick(pos) -> void:
	target_position = pos
	change_state("move")
