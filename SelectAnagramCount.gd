extends Control

onready var cursor = $Cursor

func _ready():
	cursor.visible = EngDict.pc

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_Button6_pressed():
	get_tree().change_scene("res://Anagrams6.tscn")


func _on_Button7_pressed():
	get_tree().change_scene("res://Anagrams7.tscn")

func _on_MMenuBtn_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
