extends Node
class_name StateMachine

@export var default_state: State
var current_state: State

func _ready() -> void:
	var host := get_parent()
	for child in get_children():
		assert(child is State, "%s is not a State" % [child.get_path()])
		
		child.change_state.connect(set_current_state)
		child.handle_ready(host)
	
	set_current_state(default_state)

func _process(delta: float) -> void:
	if current_state:
		current_state.handle_process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.handle_physics_process(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_unhandled_input(event)

func set_current_state(new_current_state: State) -> void:
	if current_state:
		current_state.exit()
	new_current_state.enter()
	
	current_state = new_current_state

func is_current_state(state_name: String) -> bool:
	assert(current_state, "current_state is null")
	return current_state.name == state_name

func current_state_is_default_state() -> bool:
	assert(default_state, "default_state is null")
	return current_state == default_state
