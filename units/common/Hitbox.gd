extends Area2D

onready var CollisionHit = $CollisionPolygon2D


func _ready():
	CollisionHit.disabled = true
	visible = false
