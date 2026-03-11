extends Node3D
class_name RaycastWheel

@export var suspension_strength: float = 50.0
@export var damping_strength: float = 2.0

@export var rest_distance:  float = 0.5
@export var extend_suspension_len:  float = 0.0

@export var turn_speed: float = 2.0
@export var max_turn_degrees: float = 25.0

@export var traction: float = 0.05

@export var has_motor: bool = false

@onready var ray: RayCast3D = $RayCast3D
@onready var model: MeshInstance3D = $Model

var wheel_model_radius: float

func _ready() -> void:
	wheel_model_radius = model.get_aabb().size.y/2
	ray.add_exception(get_parent())

func _update_suspension_len(delta: float):
	var suspension_len = -(rest_distance + wheel_model_radius + extend_suspension_len)
	ray.target_position.y = move_toward(ray.target_position.y, suspension_len, delta)

func _get_point_velocity_using_raycast_car(car: RaycastCar, point: Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)

func _turn(turn_dir: float, delta: float) -> void:
	if turn_dir:
		turn_dir *= turn_speed
		var max_turn = deg_to_rad(max_turn_degrees)
		var turn_rot := clampf(rotation.y + turn_dir * delta, -max_turn, max_turn)
		rotation.y = turn_rot
	else:
		rotation.y = move_toward(rotation.y, 0, turn_speed * delta)

func _rotate_model(speed: float, delta: float) -> void:
	model.rotate_x((-speed * delta) / wheel_model_radius)

func apply_forces_in_raycast_car(car: RaycastCar) -> void:
	var delta := get_process_delta_time()
	
	_update_suspension_len(delta)
	var turn_dir := Input.get_axis("game_turn_right", "game_turn_left")
	
	if !has_motor:
		_turn(turn_dir, delta)
	
	if !ray.is_colliding():
		return
	
	## APPLY SUSPENSION FORCE
	var middle_wheel := (model.global_position - Vector3(0, wheel_model_radius, 0)) - car.global_position
	var up_dir := global_transform.basis.y.normalized()
	var ray_normal := ray.get_collision_normal()
	var contact := ray.get_collision_point()
	var suspension_len := global_position.distance_to(contact)
	model.position.y = -suspension_len + wheel_model_radius
	
	var offset :=  rest_distance - suspension_len
	var suspension_force := offset * suspension_strength
	
	var contact_world_velocity := _get_point_velocity_using_raycast_car(car, contact)
	var contact_rel_velocity := up_dir.dot(contact_world_velocity)
	var damping_force := damping_strength * contact_rel_velocity
	
	var up_force := (suspension_force - damping_force) * ray_normal
	car.apply_force(up_force, middle_wheel)
	
	## APPLY TURN FORCE
	
	var right_dir := global_transform.basis.x.normalized()
	var wheel_vel := _get_point_velocity_using_raycast_car(car, model.global_position)
	var turn_vel := right_dir.dot(wheel_vel)
	var gravity: float = -car.get_gravity().y
	var apply_mass_in_wheel := (car.mass*gravity)/car.wheels.size()
	
	var x_traction := 1
	var left_car_dir := -global_basis.x.normalized()
	var x_force := left_car_dir * x_traction * turn_vel * apply_mass_in_wheel
	var back_dir := global_basis.z.normalized()
	var friction_vel := -back_dir.dot(wheel_vel)
	var friction_force := car.global_basis.z * friction_vel * traction * apply_mass_in_wheel

	var x_force_pos := contact - car.global_position
	car.apply_force(x_force, x_force_pos)
	car.apply_force(friction_force, x_force_pos)
	
	## APPLY ACCELERATION
	var forward_dir := -global_basis.z
	var speed := forward_dir.dot(car.linear_velocity)
	
	_rotate_model(speed, delta)
	
	if car.motor_input && has_motor:
		var acceleration := car.acceleration * car.motor_input
		var vector_acc_force := acceleration * forward_dir

		car.apply_force(vector_acc_force, middle_wheel)
