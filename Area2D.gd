extends Area2D

var tile_size = 32
var input = {"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN}
onready var ray = $RayCast2D
onready var tween = $Tween
export var speed = 3

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

func _process(delta):
	if tween.is_active():
		return
	for dir in input.keys():
		if Input.is_action_pressed(dir): 
			move(dir)

func move(dir):
	ray.cast_to = input[dir] * tile_size
	ray.force_raycast_update()
	if not ray.is_colliding():
		move_tween(dir)
		
func move_tween(dir):
	var direction = input[dir] * tile_size
	tween.interpolate_property(self, "position", position, position + direction, 1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
