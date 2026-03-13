@tool
extends Panel3D
class_name MainMenuPanel3D

@onready var gui: MenuGui = $SubViewport/MenuGui

signal start_button_up
signal configuration_button_up
signal credits_button_up

func _ready() -> void:
	super()
	
	gui.start_button_up.connect(start_button_up.emit)
	gui.configuration_button_up.connect(configuration_button_up.emit)
	gui.credits_button_up.connect(credits_button_up.emit)
