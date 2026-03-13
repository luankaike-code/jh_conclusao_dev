extends Node3D
class_name CameraCar

@export var default_camera_offset: float = 20.0
@export var max_camera_offset: float = 30.0

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

var raycast_car: RaycastCar

func _ready() -> void:
	var parent := get_parent()
	assert(parent is RaycastCar, "Parent is not a RaycastCar")
	
	raycast_car = parent
	set_camera_offset(default_camera_offset)

func set_camera_offset(offset: float):
	spring_arm_3d.spring_length = offset
