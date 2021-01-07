extends KinematicBody2D

onready var ray = $RayCast2D
onready var tween = $Tween
var movement = Vector2.ZERO
var target_cell = position
var speed = 5
var justMoved : bool = false
var state : int = 0

enum {DOWN, LEFT, RIGHT, UP}
var direction = DOWN
var moving:bool = false

func handled_input():
	if moving:
		return
	
	if justMoved == false:
		var target_dir = null
		state = floor(rand_range(1,4))
		print(state)
		
		if state == 1:
			target_dir = UP
		elif state == 2:
			target_dir = DOWN
		elif state == 3:
			target_dir = LEFT
		elif state == 4:
			target_dir = RIGHT
		
		if target_dir != null:
			direction = target_dir
			move(direction)
	

func move(dir):
	ray.cast_to = movement[dir] * Settings.TILE_SIZE
	ray.force_raycast_update()
	if not ray.is_colliding():
		target_cell = position + movement[dir] * Settings.TILE_SIZE
		tween.interpolate_property(self, 
			"position",
			position, 
			target_cell,
			1.0/speed, 
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT)
		moving = true
		tween.start()

func _process(delta):
	if position == target_cell:
		moving = false
	handled_input()
	
#	animate()
