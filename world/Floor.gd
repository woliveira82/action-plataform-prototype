extends Node2D

#const BaseUnit = preload("res://units/BaseUnit.tscn")
onready var unit_list = $Units
onready var enemy_list = $Enemies
#onready var Player = $Player


func _ready():
	print(pause_mode)
	randomize()
	for unit in unit_list.get_children():
		unit.set_objective($ObjectiveB)
	
	for enemy in enemy_list.get_children():
		enemy.set_objective($ObjectiveA)


func _on_Button_button_down():
	get_tree().paused = not get_tree().paused


#func _on_UnitButton_button_down():
#	var unity = BaseUnit.instance()
#	unity.set_team('player', $ObjectiveB)
#	unit_list.add_child(unity)
#
#
#func _on_EnemyButton_button_down():
#	var unity = BaseUnit.instance()
#	unity.set_team('enemy', $ObjectiveA)
#	enemy_list.add_child(unity)

