extends VBoxContainer

@onready var start_input : LineEdit = $StartContainer/StartInput
@onready var end_input : LineEdit = $EndContainer/EndInput

var node : TextStyle : set = _set_node

func _set_node(value : TextStyle) -> void:
	if not value:
		return
	node = value
	
	start_input.text = str(node.start)
	end_input.text = str(node.end)
