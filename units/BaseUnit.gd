extends KinematicBody2D

onready var AnimationPlayer = $AnimationPlayer
onready var Timer = $Timer

var velocity = Vector2.ZERO
export var walking_speed = 1200
enum {
	IDLE,
	WALKING,
	FOLLOWING,
	FIGHTING
}
export var state = IDLE
var next_state = null
var face_right = true
var _objective = null
var _enemy = null


func _ready():
	position.y = 150
	$HiiboxPivot/Hitbox/CollisionShape2D.disabled = true


func _physics_process(delta):
	match state:
		IDLE:
			velocity.x = 0
			AnimationPlayer.play("idle")

		WALKING:
			face_right = _set_face_right(_objective)
			if face_right:
				AnimationPlayer.play("walk_right")
				velocity.x = walking_speed
			else:
				AnimationPlayer.play("walk_left")
				velocity.x = -walking_speed
				
			if _is_near(_objective):
				_set_idle()

		FIGHTING:
			velocity.x = 0
			face_right = _set_face_right(_enemy)
			if face_right:
				AnimationPlayer.play("attack_right")
			else:
				AnimationPlayer.play("attack_left")

		FOLLOWING:
			# se distancia maior que x
			# walk towrd
			pass

	move_and_slide(velocity * delta)


#func set_walking():
#	next_state = WALKING
#	Timer.start(rand_range(0.2, 1.4))


func _set_idle():
	if next_state == null:
		print('set idle')
		next_state = IDLE
		Timer.start(rand_range(0.2, 1.4))


func _set_fighting():
	if next_state == null:
		next_state = FIGHTING
		Timer.start(rand_range(0.2, 1.4))


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
