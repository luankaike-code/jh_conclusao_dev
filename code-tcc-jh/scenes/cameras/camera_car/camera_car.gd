extends Node3D
class_name CameraCar

@export var default_camera_offset: float = 20.0
@export var max_camera_offset: float = 30.0
@export var influent_feedback_curve: Curve = preload("uid://ba3o3pg0251bs")

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

var raycast_car: RaycastCar

func _ready() -> void:
	var parent := get_parent()
	assert(parent is RaycastCar, "Parent is not a RaycastCar")
	
	raycast_car = parent
	set_camera_offset(default_camera_offset)

func _get_offset_feedback(car_speed: float) -> float:
	var speed_ration := car_speed / raycast_car.max_speed
	var feedback_ration := influent_feedback_curve.sample_baked(speed_ration)
	var camera_offset_range := absf(default_camera_offset - max_camera_offset)

	return default_camera_offset + (camera_offset_range*feedback_ration)

func _process(_delta: float) -> void:
	var forward_dir := -raycast_car.global_basis.z
	var car_speed := forward_dir.dot(raycast_car.linear_velocity)
	set_camera_offset(_get_offset_feedback(car_speed))

func set_camera_offset(offset: float):
	spring_arm_3d.spring_length = offset
