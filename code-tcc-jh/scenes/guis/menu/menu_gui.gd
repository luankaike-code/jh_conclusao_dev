extends Control
class_name MenuGui

@onready var start_btn: Button = $VBoxContainer/StartBtn
@onready var configuration_btn: Button = $VBoxContainer/ConfigurationBtn
@onready var credits_btn: Button = $VBoxContainer/CreditsBtn

signal start_button_up
signal configuration_button_up
signal credits_button_up

func _ready() -> void:
	start_btn.button_up.connect(start_button_up.emit)
	configuration_btn.button_up.connect(configuration_button_up.emit)
	credits_btn.button_up.connect(credits_button_up.emit)
