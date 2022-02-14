extends KinematicBody2D

onready var Sprite = $AnimatedSprite
var velocity = Vector2.ZERO
export var walking_speed = 1500
export var running_speed = 4000


func _ready():
	position.y = 531


func _physics_process(delta):
	if Input.is_action_pressed('move_right'):
		Sprite.flip_h = false
		Sprite.animation = 'walking'
		velocity.x = running_speed
	elif Input.is_action_pressed('move_left'):
		Sprite.flip_h = true
		Sprite.animation = 'walking'
		velocity.x = -running_speed
	else:
		Sprite.animation = 'idle'
		velocity.x = 0
	move_and_slide(velocity * delta)
