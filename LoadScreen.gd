extends Node

signal initialized


var small_dict = {
	
}
var word_warehouse : Dictionary = {
	
}
var six_dict = {
	
}

onready var anim_player = $AnimationPlayer

func get_small_dict():
	var file = File.new()
	file.open("res://small_dict.txt",File.READ)
	for line in file.get_len():
		var nxt_line = file.get_line()
		small_dict[nxt_line] = null
	file.close()
	EngDict.small_dict = small_dict

func create_array():
	var file = File.new()
	file.open("res://warehouse_array.txt",File.WRITE)
	file.store_var(word_warehouse)
	file.close()

#Get Certain word length
#func create_six_dict():
#	var file = File.new()
#	file.open("res://mini_dict.txt",File.READ)
#	for line in file.get_len():
#		var nxt_line = file.get_line()
#		if nxt_line.length() != 6:
#			pass
#		elif nxt_line.length() == 6:
#			six_dict[nxt_line] = null
#	file.close()
#
#func get_six_dict():
#	var file = File.new()
#	file.open("res://six_dict.txt",File.WRITE)
#	for i in len(six_dict.keys()):
#		file.store_line(six_dict.keys()[i])

func get_six_dict():
	var count = 0
	var file = File.new()
	file.open("res://six_dict.txt",File.READ)
	for line in file.get_len():
		var nxt_line = file.get_line()
		six_dict[nxt_line] = null
	file.close()
	emit_signal("initialized")
	EngDict.six_dict = six_dict


func get_warehouse():
	var count = 0
	var file = File.new()
	file.open("res://word_warehouse.txt",File.READ)
	for line in file.get_len():
		var nxt_line = file.get_line()
		word_warehouse[nxt_line] = null
		count += 1
	file.close()
	emit_signal("initialized")
	EngDict.word_warehouse = word_warehouse

func swap_scene():
	get_tree().change_scene("res://MainMenu.tscn")
	

func load_done():
	anim_player.play("fade_in")


func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	connect("initialized",self,"load_done")
	get_small_dict()
	get_six_dict()
	get_warehouse()
