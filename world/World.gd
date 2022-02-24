extends Node2D

const Enemy = preload("res://units/enemies/EnemySoldier.tscn")
onready var unit_list = $Units
onready var enemy_list = $Enemies
onready var RightEnemyDoor = $RightEnemyDoor
onready var LeftEnemyDoor = $LeftEnemyDoor
onready var PlayerDoor = $PlayerDoor


func _ready():
	randomize()


func _on_Timer_timeout():
	var enemy = Enemy.instance()
#	var door = [RightEnemyDoor, LeftEnemyDoor][randi() % 2]
	var door = RightEnemyDoor
	enemy.position = door.position
	enemy.set_objective(PlayerDoor)
	add_child(enemy)
