extends Control

@onready var start_button = $Start
@onready var exit_button = $Exit
@onready var instructions_button = $Instructions
@onready var clickEffect = $"Old-radio-button-click-97549"
@onready var hoverEffect = $"Button-124476"

@onready var start_scene = preload("res://scenes/game.tscn") as PackedScene
@onready var instructions_scene = preload("res://scenes/instructions.tscn") as PackedScene




func  _ready() -> void:

	exit_button.button_down.connect(on_exit_pressed)
	instructions_button.button_down.connect(on_instructions_pressed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Play"):
		_on_start_pressed()
		
	
func _on_start_pressed() -> void:

	get_tree().change_scene_to_packed(start_scene)
		
func on_exit_pressed() -> void:

	get_tree().quit()
	
	
func on_instructions_pressed() -> void:
	get_tree().change_scene_to_packed(instructions_scene)
	
	


func _on_start_mouse_entered() -> void:
	hoverEffect.play()


func _on_instructions_mouse_entered() -> void:
	hoverEffect.play()


func _on_exit_mouse_entered() -> void:
	hoverEffect.play()
