extends Node3D
class_name Panel3D

var is_mouse_inside: bool
var last_mouse_pos_2d: Vector2 
var last_event_time: float = -1

@onready var sub_viewport: SubViewport = $SubViewport
@onready var area_3d: Area3D = $MeshInstance3D/Area3D
@onready var mesh_3d: MeshInstance3D = $MeshInstance3D

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
	var quad_mesh_size: Vector2 = mesh_3d.mesh.size
	var now_time: float = Time.get_ticks_msec() / 1000.0
	var event_pos_3d := mesh_3d.global_transform.affine_inverse()  * event_position
	
	var mouse_pos_2d := Vector2.ZERO
	
	if  is_mouse_inside:
		mouse_pos_2d.x = event_pos_3d.x / quad_mesh_size.x
		mouse_pos_2d.y = event_pos_3d.y / quad_mesh_size.y
		
		# mouse_pos_2d.d = Range(-0.5, 0.5)
		mouse_pos_2d += Vector2.ONE / 2
		# mouse_pos_2d.d = Range(0, 1)
		
		mouse_pos_2d *= Vector2(sub_viewport.size)
	else:
		mouse_pos_2d = last_mouse_pos_2d
	
	event.position = mouse_pos_2d
	if event is InputEventMouse:
		event.global_position = mouse_pos_2d
	
	sub_viewport.push_input(event)
	
	
	
	
	
