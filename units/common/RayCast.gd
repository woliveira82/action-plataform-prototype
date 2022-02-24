extends RayCast2D

signal enemy_detected

func _process(delta):
	var collider = get_collider()
	if collider:
		emit_signal("enemy_detected", collider)
