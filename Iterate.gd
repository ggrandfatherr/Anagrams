extends Node

var pos : Array = ["BAC","CAB","PAT","ABACA"]
var string : String = "ABC"
var dict : Dictionary = {}

var tre = []
var fou = []
var fiv = []
var six = []



func _ready():
	var list  = []
	var wd = "goaded"
	
	var sp_wrd = cut(wd)
	
	for word in list:
		var is_in = false
		var word_div = cut(word)
		var dupli = sp_wrd.duplicate()
		for ltr in word_div:
			if ltr in dupli:
				dupli.erase(ltr)
				is_in = true
			else:
				is_in = false
				break
		if is_in:
			print("word ", word, " can be made from ",sp_wrd)
		else:
			print("word ", word, " cannot be made from ",sp_wrd)

	
func add_to(word):
	var length = len(word)
	match length:
		3:
			tre.append(word)
		4:
			fou.append(word)
		5: 
			fiv.append(word)
		6: 
			six.append(word)
	
#	var corr = []
#	var arr = []
#	for i in string:
#		arr.append(i)
#
#	print(arr)
#
#	for word in pos:
#		var split = cut(word)
#		print(split)
#		for ltr in split:
#			if !ltr in arr:
#				print(word, " doesn't have letter : ",ltr)
#				continue
#			elif ltr in arr:
#				print(word, " has letter : ",ltr)
#		corr.append(word)
#
#	print(corr)

func cut(_string):
	var arr = []
	for i in _string:
		arr.append(i)
	return arr
