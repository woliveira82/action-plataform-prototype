extends RayCast2D

signal enemy_detected


func _process(delta):
	var collider = get_collider()
	if collider:
		var collision_point = get_collision_point()
		var distance = abs(collider.position.x - collision_point.x)
		emit_signal("enemy_detected", collider, distance)
