extends Area2D

onready var CollisionHit = $CollisionPolygon2D


func _ready():
	CollisionHit.disabled = true
	visible = false


func activate():
	CollisionHit.disabled = false
	visible = true


func deactivate():
	CollisionHit.disabled = true
	visible = false
