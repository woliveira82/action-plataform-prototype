extends KinematicBody2D

onready var AnimationPlayer = $AnimationPlayer
onready var Camera = $Camera2D

var velocity = Vector2.ZERO
var walking_speed = 150
var life = 5
var face_right = true
enum {
	WALK,
	ATTACK
}
var state = WALK


func _physics_process(delta):
	match state:
		WALK:
			_move_state()
		ATTACK:
			_attack_state()
	Camera.position.x = 40 if face_right else -40


func _move_state():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector = input_vector.normalized()
	velocity = input_vector * walking_speed
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			AnimationPlayer.play('walk_right')
			face_right = true
		elif input_vector.x < 0:
			AnimationPlayer.play('walk_left')
			face_right = false
	else:
		AnimationPlayer.play("idle")
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func _attack_state():
	velocity = Vector2.ZERO
	if face_right:
		AnimationPlayer.play("attack_right")
	else:
		AnimationPlayer.play("attack_left")


func _on_attack_fineshed():
	state = WALK
