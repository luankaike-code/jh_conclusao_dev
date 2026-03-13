extends Node
class_name State

@warning_ignore("unused_signal")
signal change_state(state: State)

func handle_ready(_host) -> void:
	return

func enter():
	pass

func exit():
	pass

func handle_process(_delta: float) -> void:
	pass

func handle_physics_process(_delta: float) -> void:
	pass

func handle_unhandled_input(_event: InputEvent) -> void:
	pass
