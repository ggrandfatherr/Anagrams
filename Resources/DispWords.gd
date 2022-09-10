extends MarginContainer

onready var word_lbl = $HBoxContainer/MarginContainer/Panel/Label1

var word = ""
var score = ""
var norm = true

func _ready():
	if norm:
		word_lbl.text = word + " - " + score
	else:
		word_lbl.text = word
