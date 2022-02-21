extends KinematicBody2D


func _input(event):
	if event.is_action_pressed("move_left"):
		for unit in unit_list:
			unit.set_idle()
	elif event.is_action_pressed("move_right"):
		for unit in unit_list:
			unit.set_walking()
	elif event.is_action_pressed('following'):
		for unit in unit_list:
			unit.set_following(Player)
