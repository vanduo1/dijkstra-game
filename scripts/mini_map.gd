extends CanvasLayer


@export var player : CharacterBody2D
@export var tileMap : TileMap
@export var end : AnimatedSprite2D
@export var start : AnimatedSprite2D

@onready var sub_viewport = $SubViewportContainer/SubViewport

var miniPLayer: CharacterBody2D
var miniSprite: Sprite2D
var miniStart: Sprite2D
var miniStartSprite: Sprite2D
var miniEndSprite: Sprite2D
var miniEnd: AnimatedSprite2D

func _ready():
	miniPLayer = player.duplicate()
	miniEnd = end.duplicate()
	sub_viewport.add_child(tileMap.duplicate())
	sub_viewport.add_child(miniPLayer)
	sub_viewport.add_child(miniEnd)
	
	miniSprite = Sprite2D.new()
	miniSprite.texture = load("res://stuffs/pixil-frame-0 (11).png")
	miniSprite.position = Vector2(0,0)
	miniSprite.scale = Vector2(6,6)
	miniPLayer.add_child(miniSprite)
	
	
	miniEndSprite = Sprite2D.new()
	miniEndSprite.texture = load("res://stuffs/—Pngtree—smiling illustration cartoon expression_4492835.png")
	miniEndSprite.position = Vector2(0,0)
	miniEndSprite.scale = Vector2(0.07,0.07)
	miniEnd.add_child(miniEndSprite)
	
	
func _process(delta):
	miniPLayer.position = player.position
	miniEnd.position = end.position
