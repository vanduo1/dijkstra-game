extends CanvasLayer
@onready var loseEffect = $"Game-over-39-199830"
@onready var clickEffect = $"Old-radio-button-click-97549"


func _ready() -> void:
	self.hide()


func _on_try_again_pressed() -> void:
	clickEffect.play()
	get_tree().reload_current_scene()

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Play"):
		clickEffect.play()
		get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	$"../GameTimer/Timer".stop()
	get_tree().paused = true
	loseEffect.play()
	self.show()
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED


func _on_exit_pressed() -> void:
	clickEffect.play()
	get_tree().quit()
