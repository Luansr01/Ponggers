extends Control
@onready var play_button = $MarginContainer/VBoxContainer/Play
@onready var options_button = $MarginContainer/VBoxContainer/Options
@onready var quit_button = $MarginContainer/VBoxContainer/Quit

func _play_button_pressed():
	get_tree().change_scene_to_file("res://play.tscn")
func _options_button_pressed():
	print("options")
func _quit_button_pressed():
	get_tree().quit()
	
func _ready():
	play_button.pressed.connect(_play_button_pressed)
	options_button.pressed.connect(_options_button_pressed)
	quit_button.pressed.connect(_quit_button_pressed)

