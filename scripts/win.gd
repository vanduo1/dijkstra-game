extends CanvasLayer

@onready var clickEffect = $"../GameOver/Old-radio-button-click-97549"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Play"):
		get_tree().reload_current_scene()

func _on_try_again_pressed() -> void:
	clickEffect.play()
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	clickEffect.play()
	get_tree().quit()
