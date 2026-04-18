extends CanvasLayer

@onready var label = $Label
@onready var timer = $TimerLight


var is_showed = false

func  _ready() -> void:
	self.hide()
	
func time_left():
	var time_left = timer.time_left
	var second = int(time_left) % 60
	return [second]
	
func _process(delta: float) -> void:
	label.text = "%02d" % time_left()

func show_timer(is_showed):
	if is_showed:
		self.show()
		
		
func hide_timer(is_showed):
	if !is_showed:
		self.hide()
		
