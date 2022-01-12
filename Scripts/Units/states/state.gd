extends Node

class_name State

var change_state
var animation_player
var persistent_state

func _physics_process(delta) -> void:
	persistent_state.move_and_slide(persistent_state.velocity, Vector3.UP, false, 1)

func setup(change_state, animation_player, persistent_state) -> void:
	self.change_state = change_state
	self.animation_player = animation_player
	self.persistent_state = persistent_state
	
