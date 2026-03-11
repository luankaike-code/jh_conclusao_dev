extends Node3D
class_name Panel3D

var is_mouse_inside: bool
var last_mouse_pos_2d: Vector2 
var last_event_time: float = -1

@onready var sub_viewport: SubViewport = $SubViewport
@onready var area_3d: Area3D = $MeshInstance3D/Area3D

func _ready() -> void:
	area_3d.mouse_entered.connect(_on_mouse_entered_area)
	area_3d.mouse_exited.connect(_on_mouse_exited_area)
	area_3d.input_event.connect(_on_event_input_area)
	
func _on_mouse_entered_area() -> void:
	is_mouse_inside = true

func _on_mouse_exited_area() -> void:
	is_mouse_inside = false

func _process(delta: float) -> void:
	if is_mouse_inside:
		print("mouse_is_inside")
	
func _unhandled_input(event: InputEvent) -> void:
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event): # if event is a mouse event
			return
	print(event)
	sub_viewport.push_input(event)

func _on_event_input_area(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	pass
