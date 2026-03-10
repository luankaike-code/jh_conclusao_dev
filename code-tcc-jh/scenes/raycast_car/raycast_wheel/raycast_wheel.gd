extends Node3D
class_name RaycastWheel

@export var suspension_strength: float = 50.0
@export var damping_strength: float = 2.0

@export var rest_distance:  float = 0.5
@export var extend_suspension_len:  float = 0.0

@export var turn_speed: float = 2.0
@export var max_turn_degrees: float = 25.0

@export var has_motor: bool = false

@onready var ray: RayCast3D = $RayCast3D
@onready var model: MeshInstance3D = $Model

var wheel_model_radius: float

func _ready() -> void:
	wheel_model_radius = model.get_aabb().size.y/2

func _update_suspension_len(delta: float):
	var suspension_len = -(rest_distance + wheel_model_radius + extend_suspension_len)
	ray.target_position.y = move_toward(ray.target_position.y, suspension_len, delta)

func _get_point_velocity_using_raycast_car(car: RaycastCar, point: Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(car.to_local(point))

func _turn(turn_dir: float, delta: float) -> void:
	if turn_dir:
		turn_dir *= turn_speed
		var max_turn = deg_to_rad(max_turn_degrees)
		var turn_rot := clampf(rotation.y + turn_dir * delta, -max_turn, max_turn)
		rotation.y = turn_rot
	else:
		rotation.y = move_toward(rotation.y, 0, turn_speed * delta)

func apply_forces_in_raycast_car(car: RaycastCar) -> void:
	var delta := get_process_delta_time()
	
	_update_suspension_len(delta)
	var turn_dir := Input.get_axis("game_turn_right", "game_turn_left")
	
	if !has_motor:
		_turn(turn_dir, delta)
	
	if !ray.is_colliding():
		return

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
	var up_force_pos := car.to_local(model.global_position)
	
	car.apply_force(up_force, up_force_pos)
