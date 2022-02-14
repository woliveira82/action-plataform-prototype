extends KinematicBody2D

onready var Sprite = $AnimatedSprite
onready var Timer = $Timer
onready var RayCast = $RayCast2D

var velocity = Vector2.ZERO
export var walking_speed = 1200
enum {
	IDLE,
	WALKING,
	FIGHTING,
	FOLLOWING
}
var state = IDLE
var next_state = IDLE
var face_right = true
var objective = null


func _ready():
	position.y = 150


func _physics_process(delta):
	if objective:
		var distance = position - objective.position.x
		if abs(distance) < 50:
			
			state = IDLE

	match state:
		IDLE:
			Sprite.animation = 'idle'
			velocity.x = 0
		WALKING:
			Sprite.animation = 'walking'
			velocity.x = walking_speed
			if not face_right:
				velocity.x *= -1
				Sprite.flip_h = true
				RayCast.cast_to.x *= -1
		FIGHTING:
			Sprite.animation = 'attacking'
			velocity.x = 0
		FOLLOWING:
			# se distancia maior que x
			# walk towrd
			pass
	move_and_slide(velocity * delta)


func set_walking():
	next_state = WALKING
	Timer.start(rand_range(0.2, 1.4))


func set_idle():
	next_state = IDLE
	Timer.start(rand_range(0.2, 1.4))


func set_following():
	next_state = FOLLOWING
	Timer.start(rand_range(0.2, 1.4))


func _on_Timer_timeout():
	state = next_state
	next_state = IDLE
