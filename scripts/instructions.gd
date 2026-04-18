extends Node2D

@onready var back_button = $Button

#@onready var main_menu = preload("res://scenes/main_menu.tscn") as PackedScene

func  _ready() -> void:
	back_button.button_down.connect(on_back_pressed)
	

func on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
