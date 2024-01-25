extends PanelContainer

@onready var message : Label = $VBoxContainer/HBoxContainer/Message
@onready var close_button : Button = $VBoxContainer/HBoxContainer/CloseButton

func init(_message : String = '', with_close_button : bool = true, _timer : float = 3.0) -> void:
	if not with_close_button:
		close_button.hide()

	message.text = _message
	if _timer > 0:
		get_tree().create_timer(_timer).timeout.connect(close)
	

func close() -> void:
	var tween : Tween = get_tree().create_tween()
	
	tween.parallel().tween_property(self, "modulate:a", 0, 1.0).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "position:x", position.x + 300, 1.0).set_trans(Tween.TRANS_BACK)
	
	tween.tween_callback(queue_free)

func _on_close_button_pressed():
	close()
