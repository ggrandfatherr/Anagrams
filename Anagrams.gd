extends Node2D

const small_dict : Dictionary = {
	
}

var arr_dict = ["DEAD","MAN","MANE","DAD","MAD","DEADMAN"]

var enter = false

var used_words = []

var word : String = "DEADMAN"

var used = false
var str_valid = false

var word_arr = []
var formed_arr = []
var formed_string = ""

var points = 0

onready var submit_button = $CanvasLayer/Control/GreaterVBox/SubmitCont/SubmitText
onready var point_label = $CanvasLayer/Control/GreaterVBox/PointContainer/PointLabel
onready var word_grid = $CanvasLayer/Control/GreaterVBox/WordContainer/WordGrid
onready var button_grid = $CanvasLayer/Control/GreaterVBox/ButtonCont/ButtonGrid

var curr_box = 0
var text_buttons = []
var button_arr = []

func _ready():
	var n = "penis"
	n.erase(n.length()-1,1)
	
	print(n)
	
	
	text_buttons = word_grid.get_children()
	
	
	
	word_arr = split_string(word)
	button_arr = button_grid.get_children()
	word_arr.resize(button_arr.size())
	word_arr.shuffle()
	
	print(word_arr)
	
	for i in text_buttons.size():
#		text_buttons[i].text = word_arr[i]
		text_buttons[i].connect("pressed",self,"clear_box",[i])
	
	for i in text_buttons.size():
		print(text_buttons[i],i)

	for i in button_arr.size():
		button_arr[i].connect("pressed",self,"fill_box",[word_arr[i],i,button_arr[i]])
		button_arr[i].text = word_arr[i]

func _process(delta):
	for i in len(formed_arr):
		text_buttons[i].text = formed_arr[i]
#		text_buttons[i].filled = true
	
	point_label.text = str(points)
#	submit_button.disabled = formed_string.length() < 3
	str_valid = formed_string in arr_dict
	used = formed_string in used_words
#
#func validate_word():
#	print("You spelt: ",formed_string)
#	if str_valid and !used:
#		points += formed_string.length() * 100
#		used_words.append(formed_string)
#		formed_string = ""
#		print("Cleared~\n",points, " points")
#		clear_boxes()
#	elif used:
#		print("Used Before!")
#		formed_string = ""
#		clear_boxes()
#	else:
#		clear_boxes()
#
#func clean_last():
#	if formed_string.length() == 1:
#		formed_string = ""
#	else:
#		formed_string.erase(formed_string.length()-1,1)
#
func split_string(string: String):
	string.to_upper()
	var word_len = string.length()
	var string_array = []
	while word_len > 0:
		string_array.append(string.right(word_len -1))
		string.erase(word_len -1,1)
		word_len = string.length()

	string_array.invert()
	return string_array

#func clear_boxes():
#	for btn in text_buttons:
#		clear_box(btn)

func clear_box(id):
	if formed_arr.empty() or id >= formed_arr.size():
		return
	
	var letter = formed_arr[id]
	print(text_buttons[id]," and index is: ",text_buttons[id].letter_index)
	print("button is: ",button_arr[text_buttons[id].letter_index]," and ",letter)
	button_arr[text_buttons[id].letter_index].text = word_arr[text_buttons[id].letter_index]
	button_arr[text_buttons[id].letter_index].disabled = false
	text_buttons[id].letter_index = 0

	for i in len(formed_arr):
		text_buttons[i].text = ""
		text_buttons[i].filled = false
	formed_arr[id] = ""
	formed_arr.erase("")
	
	if formed_arr.empty():
		pass
	else:
		for i in len(formed_arr):
			text_buttons[i].text = formed_arr[i-1]
			text_buttons[i].filled = true
	
	
	print(formed_arr,id)
	

func fill_box(letter,letter_index,btn):
	formed_arr.append(letter)
	print(formed_arr.size()," and ",letter_index, " and ", btn," and ",letter)
	btn.text = ""
	text_buttons[formed_arr.size()-1].letter_index = letter_index
#	print(text_buttons[formed_arr.size()])
	btn.disabled = true


func _on_Button_pressed():
#	formed_arr.append("o")
#	validate_word()
	pass
