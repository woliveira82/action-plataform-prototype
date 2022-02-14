extends Node2D

onready var unit_list = $Units.get_children()
onready var enemy_list = $Enemies.get_children()
onready var Player = $Player


func _ready():
	randomize()
	for unit in unit_list:
		unit.set_walking()
	
	for enemy in enemy_list:
		enemy.set_walking()
		enemy.face_right = false
		enemy.collision_layer = 4
		enemy.collision_mask = 3


#func _input(event):
#	if event.is_action_pressed("rest"):
#		for unit in unit_list:
#			unit.set_idle()
#	elif event.is_action_pressed("advance"):
#		for unit in unit_list:
#			unit.set_walking()
#	elif event.is_action_pressed('following'):
#		for unit in unit_list:
#			unit.set_following(Player)
