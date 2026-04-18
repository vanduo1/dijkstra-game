extends Camera2D

func _ready() -> void:
	self.zoom = Vector2(1, 1)

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("zoom_in") :
		self.zoom += Vector2(0.1, 0.1)
	if event.is_action_pressed("zoom_out") && self.zoom > Vector2(1.1, 1.1):
		self.zoom -= Vector2(0.1, 0.1)
