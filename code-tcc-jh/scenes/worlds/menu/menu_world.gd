extends Node3D

@onready var main_menu_panel_3d: MainMenuPanel3D = $main_menu_panel_3D

func _ready() -> void:
	main_menu_panel_3d.start_button_up.connect(_on_start_button_up)
	main_menu_panel_3d.configuration_button_up.connect(_on_configuration_button_up)
	main_menu_panel_3d.credits_button_up.connect(_on_credits_button_up)

func _on_start_button_up():
	print("start")

func _on_configuration_button_up():
	print("configurações")

func _on_credits_button_up():
	print("creditos")
