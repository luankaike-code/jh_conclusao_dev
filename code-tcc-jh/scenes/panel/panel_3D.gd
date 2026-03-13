@tool
extends Node3D
class_name Panel3D

@export var viewport_size: Vector2 = Vector2(512, 512) :
	set(new):
		viewport_size = new
		_update_viewport_size()

@export var mesh_size: Vector2 = Vector2(1, 1) :
	set(new):
		mesh_size = new
		_update_mesh_size()

@export var default_viewport_child: PackedScene :
	set(new):
		default_viewport_child = new
		set_viewport_content(new)

var is_mouse_inside: bool
var last_event_pos_2d: Vector2 
var last_event_time: float = -1

@onready var sub_viewport: SubViewport = $SubViewport
@onready var area_3d: Area3D = $MeshInstance3D/Area3D
@onready var area_3d_collision: CollisionShape3D = $MeshInstance3D/Area3D/CollisionShape3D
@onready var mesh_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	area_3d.mouse_entered.connect(_on_mouse_entered_area)
	area_3d.mouse_exited.connect(_on_mouse_exited_area)
	area_3d.input_event.connect(_on_event_input_area)
	
	
	_update_viewport_size()
	_update_mesh_size()
	
	if default_viewport_child:
		set_viewport_content(default_viewport_child)

func _update_viewport_size():
	if sub_viewport:
		sub_viewport.size = viewport_size

func _update_mesh_size():
	if area_3d_collision && mesh_3d:
		area_3d_collision.shape.size = Vector3(mesh_size.x, mesh_size.y, 0.01)
		mesh_3d.mesh.size = mesh_size

func _on_mouse_entered_area() -> void:
	is_mouse_inside = true

func _on_mouse_exited_area() -> void:
	is_mouse_inside = false
	
func _unhandled_input(event: InputEvent) -> void:
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event): # if event is a mouse event
			return
	sub_viewport.push_input(event)

func _on_event_input_area(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	var now_event_time: float = Time.get_ticks_msec() / 1000.0
	var event_pos_3d := mesh_3d.global_transform.affine_inverse()  * event_position
	
	var event_pos_2d := Vector2.ZERO
	
	if  is_mouse_inside:
		event_pos_2d.x = event_pos_3d.x / mesh_size.x
		event_pos_2d.y = event_pos_3d.y / mesh_size.y
		
		# event_pos_2d.d = Range(-0.5, 0.5)
		event_pos_2d += Vector2.ONE / 2
		# event_pos_2d.d = Range(0, 1)
		
		event_pos_2d *= Vector2(sub_viewport.size)
	else:
		event_pos_2d = last_event_pos_2d
	
	event.position = event_pos_2d
	if event is InputEventMouse:
		event.global_position = event_pos_2d
		
	if event is InputEventMouseMotion || event is InputEventScreenDrag:
		event.relative = event_pos_2d - last_event_pos_2d
		event.velocity = event.relative / (now_event_time - last_event_time)
	
	last_event_pos_2d = event_pos_2d
	last_event_time = now_event_time
	
	sub_viewport.push_input(event)
	
func set_viewport_content(packed_scene: PackedScene) -> CanvasItem:
	if !sub_viewport:
		return
	
	var scene: CanvasItem = packed_scene.instantiate()
	
	for sub_viewport_child in sub_viewport.get_children():
		sub_viewport_child.queue_free()
		
	sub_viewport.add_child(scene)
	return scene

	
