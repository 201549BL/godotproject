extends Area2D

var tile_size = 32
var input = {"ui_right": Vector2.RIGHT, "ui_left": Vector2.LEFT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN}
var direction = {"ui_right": "idle right", "ui_left": "idle left", "ui_up": "idle up", "ui_down": "Idle down"}
var duration_pressed = 0
var max_duration = 10.0


onready var anim = $AnimationPlayer
onready var ray = $RayCast2D
onready var tween = $Tween
export var speed = 3

func _ready():
	position = position.snapped(Vector2.ONE * tile_size / 2)
	position += Vector2.ONE * tile_size / 2
	duration_pressed = 0

func _process(delta):
	print(duration_pressed)
	if tween.is_active():
		return
	for dir in input.keys():
		if Input.is_action_pressed(dir):
			pressed(delta)
			move(dir)
			animate(dir)
		elif duration_pressed != 0:
			duration_pressed = lerp(duration_pressed, 0, 0.25)


func move(dir):
	ray.cast_to = input[dir] * tile_size
	ray.force_raycast_update()
	if not ray.is_colliding() and duration_pressed > 2.8:
		move_tween(dir)

func idle_move(dir):
	ray.cast_to = input[dir] * tile_size
	ray.force_raycast_update()

func move_tween(dir):
	var direction = input[dir] * tile_size
	tween.interpolate_property(self, "position", position, position + direction, 1.0 / speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
func animate(dir):
	anim.play(direction[dir])

func pressed(delta):
	duration_pressed += delta * 100
	duration_pressed = min(duration_pressed, max_duration)
	


