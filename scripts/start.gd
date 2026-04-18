extends AnimatedSprite2D


func _process(delta: float) -> void:
	self.position = $"../Player".position + Vector2(0,-90)
