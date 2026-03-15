extends Node
class_name WorldManager

@export var default_world_id: WorldEnums.id
var current_world: World

func _ready() -> void:	
	change_current_world(default_world_id)

func change_current_world(world_id: WorldEnums.id) -> void:
	var packed_world := WorldEnums.packed_scenes[world_id]
	var world: World = packed_world.instantiate()
	
	world.change_world.connect(change_current_world)
	
	if current_world:
		current_world.queue_free()
	add_child(world)
	
	current_world = world
	
