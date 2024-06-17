extends Window

func _on_close_requested():
	hide()
	queue_free()
