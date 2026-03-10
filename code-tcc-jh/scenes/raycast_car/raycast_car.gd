extends RigidBody3D
class_name RaycastCar

@export var wheels: Array[RaycastWheel]

func _physics_process(delta: float) -> void:
	for wheel in wheels:
		wheel.apply_forces_in_raycast_car(self)
