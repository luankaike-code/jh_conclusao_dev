@tool
extends Node3D
class_name SpeedBumps

@export var speed_bump_count: int = 5 : 
	set(new):
		speed_bump_count = new
		_update_speed_bumps()

@export var spacing: Vector3 = Vector3(0, 0, -1) : 
	set(new):
		spacing = new
		_update_speed_bumps()

@export var speed_bump_degrees_rotation: Vector3 = Vector3(0, 0, 90) : 
	set(new):
		speed_bump_degrees_rotation = new
		_update_speed_bumps()

@export var speed_bump_height: float = 5.0 : 
	set(new):
		speed_bump_height = new
		_update_speed_bumps()

@export var speed_bump_radius: float = 0.5 : 
	set(new):
		speed_bump_radius = new
		_update_speed_bumps()

@export var material: Material = preload("uid://bm7ahbfh6uxjy") : 
	set(new):
		material = new
		_update_speed_bumps()

var _speed_bumps: Array[CSGCylinder3D]

func _ready() -> void:
	_update_speed_bumps()

func _update_speed_bumps() -> void:
	for sp in _speed_bumps:
		sp.queue_free()
	_speed_bumps.clear()
	
	for i in speed_bump_count:
		var speed_bump_scene := CSGCylinder3D.new()
		
		speed_bump_scene.use_collision = true
		speed_bump_scene.position = spacing * i
		speed_bump_scene.rotation_degrees = speed_bump_degrees_rotation
		speed_bump_scene.height = speed_bump_height
		speed_bump_scene.radius = speed_bump_radius 
		speed_bump_scene.material = material
		
		_speed_bumps.push_back(speed_bump_scene)
		add_child(speed_bump_scene)
