extends KinematicBody2D

onready var AnimationPlayer = $AnimationPlayer
onready var Timer = $Timer

export var velocity = Vector2.ZERO
var walking_speed = 1200
var jump_speed = 2400
var life = 2
enum {
	IDLE,
	WALKING,
	FIGHTING
}
export var state = IDLE
enum {
	WAIT,
	ATTACK,
	ADVANCE,
	RETREAT,
	ADJUST
}
var fighting_state = WAIT
var next_state = null
var face_right = true

var _objective = null
var _enemy = true


func _ready():
	$Sprite.scale = Vector2.ONE
	$Sprite.position = Vector2.ZERO
	$CollisionShape2D.disabled = false


func _physics_process(delta):
	match state:
		IDLE:
			_state_idle()
		WALKING:
			if not is_instance_valid(_objective) or not _objective:
				_set_idle()
				continue
			_state_walking()
		FIGHTING:
			if not is_instance_valid(_enemy):
				_enemy = null
				state = IDLE
				continue
			_state_fighting()
	velocity = move_and_slide(velocity * delta)


func _state_idle():
	if is_instance_valid(_objective):
		_set_walking()
	velocity.x = 0
	AnimationPlayer.play("idle")


func _state_walking():
	face_right = _set_face_right(_objective)
	if face_right:
		AnimationPlayer.play("walk_right")
		velocity.x = walking_speed
	else:
		AnimationPlayer.play("walk_left")
		velocity.x = -walking_speed
		
	if _is_near(_objective):
		_objective = null


func _state_fighting():
	face_right = _set_face_right(_enemy)
	match fighting_state:
		WAIT:
			velocity.x = 0
			var distance = abs(position.x - _enemy.position.x)
			if distance > 60:
				state = IDLE
			elif distance > 40:
				fighting_state = ADVANCE
			elif distance < 25:
				fighting_state = RETREAT
			elif distance > 30 and distance < 35:
				fighting_state = ATTACK
			else:
				fighting_state = ADJUST
		ATTACK:
			velocity.x = 0
			if face_right:
				AnimationPlayer.play("attack_right")
			else:
				AnimationPlayer.play("attack_left")
		ADVANCE:
			velocity.x = jump_speed if face_right else -jump_speed
			if face_right:
				AnimationPlayer.play("jump_right")
			else:
				AnimationPlayer.play("jump_left")
		RETREAT:
			velocity.x = -jump_speed if face_right else jump_speed
			if face_right:
				AnimationPlayer.play("attack_right")
			else:
				AnimationPlayer.play("attack_left")
		ADJUST:
			velocity.x = walking_speed if face_right else -walking_speed
			_set_wait()


func _set_wait():
	fighting_state = WAIT


func _set_walking():
	if next_state == null:
		next_state = WALKING
		Timer.start(rand_range(0.2, 1.4))


func _set_idle():
	if next_state == null:
		next_state = IDLE
		Timer.start(rand_range(0.2, 1.4))


func _set_fighting():
	if next_state == null:
		fighting_state = WAIT
		next_state = FIGHTING
		Timer.start(rand_range(0.2, 0.6))


func _is_near(objective):
	var distance = abs(global_position.x - objective.position.x)
	return true if distance < 50.0 else false


func _set_face_right(objective):
	var difference = global_position.x - objective.position.x
	return difference < 0


func set_objective(objective):
	_objective = objective
	state = WALKING


func _on_RayCastRight_enemy_detected(enemy):
	_set_fighting()
	_enemy = enemy


func _on_RayCastLeft_enemy_detected(enemy):
	_set_fighting()
	_enemy = enemy


func _on_Timer_timeout():
	state = next_state
	next_state = null


func _on_Hurtbox_area_entered(area):
	life -= 1
	modulate = Color(1, 0.5, 0.5, 1)
	if area.global_position.x > global_position.x:
		global_position.x -= 10
	else:
		global_position.x += 10
	if life <= 0:
		queue_free()
