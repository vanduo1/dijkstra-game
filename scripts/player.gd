extends CharacterBody2D


const speed = 80
const acceleration = 15

var input: Vector2
var able_to_move = true

func get_input():
	if(able_to_move):
		input.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
		input.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
		return input.normalized()
	
func _ready() -> void:

	pass
	
	


func _physics_process(delta: float) -> void:
	if able_to_move:
		var playerInput = get_input()
		velocity = lerp(velocity, playerInput * speed, delta * acceleration)
		move_and_slide()


func move(move):
	able_to_move = move
	


#func _on_timer_timeout() -> void:
	##able_to_move = false
	#get_tree().paused
