extends Control


onready var game_name = $VBoxContainer/MarginContainer/VBoxContainer/GameName

onready var cursor = $Cursor

var list = EngDict.small_dict
var pos_list = []

func _ready():
	cursor.visible = EngDict.pc

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_StartGame_pressed():
	get_tree().change_scene("res://SelectAnagramCount.tscn")


func _on_EndGame_pressed():
	get_tree().quit()


func _on_ConfirmationDialog_confirmed():
	get_tree().quit()
