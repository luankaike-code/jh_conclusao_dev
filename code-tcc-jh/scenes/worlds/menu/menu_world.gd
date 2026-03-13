extends Node3D

@onready var main_menu_panel_3d: MainMenuPanel3D = $menus/main_menu_panel_3D
@onready var camera: Camera3D = $Camera3D
@onready var menu_configuration_path: Path3D = $paths/MenuConfiguration

var path_to_follow: Path3D
var current_point_index := 0
var points_count: float

func _ready() -> void:
	main_menu_panel_3d.start_button_up.connect(_on_start_button_up)
	main_menu_panel_3d.configuration_button_up.connect(_on_configuration_button_up)
	main_menu_panel_3d.credits_button_up.connect(_on_credits_button_up)

func _process(delta: float) -> void:
	if path_to_follow:
		points_count += 0.01
		var pos := path_to_follow.curve.sample_baked_with_rotation(points_count)
		camera.global_position = ((path_to_follow.global_position + pos.origin))
		camera.basis = pos.basis

func _on_start_button_up():
	get_tree().change_scene_to_file("uid://dhrvq381488f3")

func _on_configuration_button_up():
	path_to_follow = menu_configuration_path

func _on_credits_button_up():
	print("creditos")
