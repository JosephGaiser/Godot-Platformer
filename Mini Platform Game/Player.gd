extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const WEIGHT = 0.2
const WEIGHT_FALLING = 0.05
const MAX_SPEED = 400
const JUMP_HEIGHT = -550
var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	motion = move_and_slide(getMotion(), UP)
	
func getMotion():
	var sprite = get_node("Sprite")
	var friction = true
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		run_animation(sprite, false)
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		run_animation(sprite, true)
	else:
		sprite.play("Idle")
		friction = true
		
	if is_on_floor():
		if  Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction:
			motion.x = lerp(motion.x, 0, WEIGHT)
	else:
		if motion.y < 0:
			sprite.play("Jump")
		else:
			sprite.play("Fall")
		if friction:
			motion.x = lerp(motion.x, 0, WEIGHT_FALLING)
			
	return motion

func run_animation(sprite, boolean):
	sprite.flip_h = boolean
	sprite.play("Run")