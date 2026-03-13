extends Camera3D
class_name CameraFollowerPath

@onready var state_machine: StateMachine = $StateMachine
@onready var following_state: State = $StateMachine/Following

@export var follow_speed: float = 1.0

var current_path: Path3D
var follow_reverse: bool

func follow_path(path: Path3D, reverse: bool = false) -> void:
	print(state_machine.current_state_is_default_state())
	if !state_machine.current_state_is_default_state():
		return
	
	follow_reverse = reverse
	current_path = path
	state_machine.set_current_state(following_state)
