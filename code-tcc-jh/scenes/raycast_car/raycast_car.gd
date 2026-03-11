extends RigidBody3D
class_name RaycastCar

@export var wheels: Array[RaycastWheel]

@export var max_speed: float = 50.0

@export var acceleration: float = 800.0
@export var deceleration: float = 100.0
@export var acceleration_curve: Curve = preload("res://data/curves/acceleration_curve.tres")

var hand_brake: bool = false
var motor_input: int

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	for wheel in wheels:
		wheel.is_lock = hand_brake
		wheel.apply_forces_in_raycast_car(self)

func _input_pressed_or_released(action: StringName, pressed: Variant, released: Variant, default: Variant) -> Variant:
	if Input.is_action_just_pressed(action):
		return pressed
	elif Input.is_action_just_released(action):
		return released
	
	return default

@warning_ignore("unused_parameter")
func _unhandled_input(event: InputEvent) -> void:
	motor_input = _input_pressed_or_released("game_acceleration", 1.0, 0, motor_input)
	motor_input = _input_pressed_or_released("game_deceleration", -1.0, 0, motor_input)
	hand_brake = _input_pressed_or_released("game_hand_brake", true, false, hand_brake)
