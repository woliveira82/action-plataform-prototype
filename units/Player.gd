extends KinematicBody2D

onready var AnimationPlayer = $UnitSprite/AnimationPlayer

var velocity = Vector2.ZERO
var walking_speed = 150
var fighting_speed = 150
var life = 5
var face_right = true


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector = input_vector.normalized()
	velocity = input_vector * walking_speed
	if input_vector.x > 0:
		AnimationPlayer.play('walk_right')
	elif input_vector.x < 0:
		AnimationPlayer.play('walk_left')
	else:
		AnimationPlayer.play("idle")
	velocity = move_and_slide(velocity)
