class_name WorldEnums

enum id {
	menu,
	test
}

static var packed_scenes: Dictionary[id, PackedScene] = {
	id.menu: preload("res://scenes/worlds/menu/menu_world.tscn"),
	id.test: preload("res://scenes/worlds/test/test_world.tscn")
}
