extends World

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		change_world.emit(WorldEnums.id.menu)
