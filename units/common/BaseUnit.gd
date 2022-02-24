extends KinematicBody2D

const blue_knight = preload("res://assets/blueknight.png")
const red_knight = preload("res://assets/redknight.png")
const gold_knight = preload("res://assets/goldknight.png")
onready var AnimationPlayer = $AnimationPlayer
onready var Timer = $Timer

var velocity = Vector2.ZERO
var walking_speed = 1200
var fighting_speed = 150
var life = 2
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
	position.y = 100
	$Hitbox/CollisionShape2D.disabled = true


func set_team(team, objective):
	if team == 'player':
		collision_layer = 4
		collision_mask = 9
		$Hitbox.collision_layer = 4
		$Hitbox.collision_mask = 8
		$Hurtbox.collision_layer = 4
		$Hurtbox.collision_mask = 8
		position.x = 75
		$RayCastLeft.collision_mask = 8
		$RayCastRight.collision_mask = 8
		$Sprite.texture = blue_knight
	else:
		collision_layer = 8
		collision_mask = 5
		$Hitbox.collision_layer = 8
		$Hitbox.collision_mask = 4
		$Hurtbox.collision_layer = 8
		$Hurtbox.collision_mask = 4
		position.x = 250
		$RayCastLeft.collision_mask = 4
		$RayCastRight.collision_mask = 4
	_objective = objective


func _physics_process(delta):
	match state:
		IDLE:
			if is_instance_valid(_objective):
				_set_walking()
			velocity.x = 0
			AnimationPlayer.play("idle")

		WALKING:
			if not is_instance_valid(_objective) or not _objective:
				_set_idle()
				continue
				
			face_right = _set_face_right(_objective)
			if face_right:
				AnimationPlayer.play("walk_right")
				velocity.x = walking_speed
			else:
				AnimationPlayer.play("walk_left")
				velocity.x = -walking_speed
				
			if _is_near(_objective):
				_objective = null

		FIGHTING:
			if not is_instance_valid(_enemy):
				_enemy = null
				state = IDLE
				continue
		
			face_right = _set_face_right(_enemy)
			if face_right:
				AnimationPlayer.play("attack_right")
				velocity.x = fighting_speed
			else:
				AnimationPlayer.play("attack_left")
				velocity.x = -fighting_speed
				

		FOLLOWING:
			# se distancia maior que x
			# walk towrd
			pass

	move_and_slide(velocity * delta)


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
