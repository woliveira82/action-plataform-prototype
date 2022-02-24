extends CanvasLayer


func _on_PauseButton_button_down():
	get_tree().paused = not get_tree().paused
