extends State

@onready var idle_state: Node = $"../Idle"

var host: CameraFollowerPath
var current_path: Path3D
var max_offset: float
var current_offset: float
var reverse: bool
		

func enter():
	current_path = host.current_path
	reverse = host.follow_reverse
	max_offset = 0.0 if reverse else current_path.curve.get_baked_length()
	current_offset = current_path.curve.get_baked_length() if reverse else 0.0

func handle_ready(host_: CameraFollowerPath) -> void:
	host = host_

func handle_process(delta: float) -> void:
	var point_transform := host.current_path.curve.sample_baked_with_rotation(current_offset)
	
	var pos := current_path.global_position + point_transform.origin
	host.global_position += pos - host.global_position
	host.global_transform.basis = point_transform.basis
	
	current_offset += -host.follow_speed * delta if reverse else host.follow_speed * delta
	
	if (current_offset > max_offset && !reverse) || (current_offset < max_offset && reverse):
		change_state.emit(idle_state)
