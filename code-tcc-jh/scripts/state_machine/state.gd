extends Node
class_name State

@warning_ignore("unused_signal")
signal change_state(state: State)

@warning_ignore("unused_parameter")
func handle_ready(host) -> void:
	return

func enter():
	pass

func exit():
	pass

@warning_ignore("unused_parameter")
func handle_process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func handle_physics_process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func handle_unhandled_input(event: InputEvent) -> void:
	pass
