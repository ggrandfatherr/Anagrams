extends Position2D

const error_message = preload("res://Resources/ErrorMessage.tscn")

func create_error_message(message : String, blink = false):
	var err_instance = error_message.instance()
	err_instance.blink = blink
	err_instance.text = message
	add_child(err_instance)
