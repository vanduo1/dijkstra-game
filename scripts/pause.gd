extends Node2D


func _input(event: InputEvent) -> void:
	#----------pause game----------#
	if event.is_action_pressed("Pause"):
	
		if get_tree().paused == false:
			$"../Player/Camera2D".zoom = Vector2(1, 1)
			$"../Message".show()
			get_tree().paused = true
		elif get_tree().paused == true:
			$"../Player/Camera2D".zoom = Vector2(2.7, 2.7)
			get_tree().paused = false;
			$"../Message".hide()
