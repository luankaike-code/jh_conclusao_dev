extends Node3D

@onready var main_menu_panel: MainMenuPanel3D = $menus/main_menu_panel_3D
@onready var configuration_panel: MainMenuPanel3D = $menus/main_menu_panel_3D2
@onready var cameraFP: CameraFollowerPath = $CameraFollowerPath
@onready var menu_configuration_path: Path3D = $paths/MenuConfiguration

func _ready() -> void:
	main_menu_panel.start_button_up.connect(start_game)
	main_menu_panel.configuration_button_up.connect(to_configuration_panel)
	configuration_panel.credits_button_up.connect(to_main_menu_panel)

func start_game():
	get_tree().change_scene_to_file("uid://dhrvq381488f3")

func to_configuration_panel():
	cameraFP.follow_path(menu_configuration_path)

func to_main_menu_panel():
	cameraFP.follow_path(menu_configuration_path, true)
